import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditasyon_uygulamasi/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class AyarlarSayfasi extends StatefulWidget {
  @override
  _AyarlarSayfasiState createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {

  TimeOfDay? _seciliSaat;
  bool _yuklendi = false;

  @override
  void initState() {
    super.initState();

    _yukleSaat();
  }

  
Future<void> _zamanlayiciKur(TimeOfDay saat) async {
 
  final androidDetails = AndroidNotificationDetails(
    'meditasyon_kanali',
    'Meditasyon Bildirimleri',
    importance: Importance.max,
    priority: Priority.high,
  );

  final details = NotificationDetails(android: androidDetails);

  final now = DateTime.now();
  final ilkBildirim = DateTime(now.year, now.month, now.day, saat.hour, saat.minute);

  

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Meditasyon Zamanı',
    'Bugün için birkaç dakikanı ayırmayı unutma 🧘',
    _saattenZoned(ilkBildirim),
    details,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
    payload: 'meditasyon',
  );

  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('saat_saat', saat.hour);
prefs.setInt('saat_dakika', saat.minute);
  await prefs.setString('bildirim_saat', '${saat.hour}:${saat.minute}');
  debugPrint('Saat kaydedildi: ${saat.hour}:${saat.minute}');
}


tz.TZDateTime _saattenZoned(DateTime dateTime) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    dateTime.hour,
    dateTime.minute,
  );
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(Duration(days: 1));
  }
  return scheduledDate;
}



Future<void> kontrolEtVeGerekirseIzinAl(BuildContext context) async {
  if (!Platform.isAndroid) return;

  final alarmPermission = await Permission.scheduleExactAlarm.status;

  if (alarmPermission.isGranted) {
    debugPrint('⏰ Exact Alarm izni zaten verilmiş.');
    return; 
  }

  final devamEt = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Bildirim İzni Gerekli'),
      content: Text(
        'Seçtiğiniz saatte günlük bildirim alabilmeniz için cihaz ayarlarından "Tam Alarm İzni" vermeniz gerekiyor.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('İptal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('İzin Ver'),
        ),
      ],
    ),
  );

  if (devamEt == true) {
    final intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
    await intent.launch();
  }
}

Future<void> _yukleSaat() async {
  
  final prefs = await SharedPreferences.getInstance();
  
if (prefs.containsKey('saat_saat') && prefs.containsKey('saat_dakika')) {
  
  setState(() {
    _seciliSaat = TimeOfDay(
      hour: prefs.getInt('saat_saat')!,
      minute: prefs.getInt('saat_dakika')!,
    );
    _yuklendi = true;
  });
} else {
  setState(() {
    _yuklendi = true;
  });
}

}


void _saatSec() async {
  await kontrolEtVeGerekirseIzinAl(context);

  final TimeOfDay? yeniSaat = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  if (yeniSaat != null) {
    setState(() {
      _seciliSaat = yeniSaat;
    });
    await _zamanlayiciKur(yeniSaat);
  }
}

@override
Widget build(BuildContext context) {
  if (!_yuklendi) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
         backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        title: Text('Ayarlar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  return Scaffold(
    backgroundColor: Colors.blue,
    appBar: AppBar(
      centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
         backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      title: Text('Ayarlar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
   
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bildirim Ayarları',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Icon(Icons.alarm, color: Colors.blue, size: 30),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Günlük Bildirim Saati',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _seciliSaat != null
                              ? '${_seciliSaat!.hour.toString().padLeft(2, '0')}:${_seciliSaat!.minute.toString().padLeft(2, '0')}'
                              : 'Henüz seçilmedi',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text('Seç', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                    onPressed: _saatSec,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 12),
          Text(
            '🔔 Seçtiğiniz saatte cihazınıza her gün hatırlatma bildirimi gönderilir. Dilerseniz bu saati tekrar güncelleyebilirsiniz.',
            style: TextStyle(fontSize: 14, color: Colors.white),
          )
        ],
      ),
    ),
  );
}
}
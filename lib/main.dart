import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditasyon_uygulamasi/pages/ana_sayfa.dart';
import 'package:meditasyon_uygulamasi/pages/gunluk_takip_sayfasi.dart';
import 'package:meditasyon_uygulamasi/pages/meditasyon_sayfasi.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meditasyon_uygulamasi/pages/nefes_egzersizi_sayfasi.dart';
import 'package:meditasyon_uygulamasi/pages/ayarlar_sayfasi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

tz.initializeTimeZones(); 
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul')); 
  await _initializeNotifications();

  await initializeDateFormatting('tr_TR');
  runApp(MeditasyonUygulamasi());
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

 
  if (await Permission.notification.isDenied ||
      await Permission.notification.isRestricted) {
    await Permission.notification.request();
  }
}


class MeditasyonUygulamasi extends StatelessWidget {
  const MeditasyonUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sağlık ve Meditasyon',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Arial',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AnaSayfa(),
        '/meditasyon': (context) => MeditasyonSayfasi(),
        '/gunluk': (context) => GunlukTakipSayfasi(),
        '/nefes': (context) => NefesEgzersiziSayfasi(),
        '/ayarlar': (context) => AyarlarSayfasi(),
      },
    );
  }
}

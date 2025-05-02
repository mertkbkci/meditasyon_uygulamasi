
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'dart:convert';

// class GunlukTakipSayfasi extends StatefulWidget {
//   const GunlukTakipSayfasi({super.key});

//   @override
//   State<GunlukTakipSayfasi> createState() => _GunlukTakipSayfasiState();
// }

// class _GunlukTakipSayfasiState extends State<GunlukTakipSayfasi> {
//   late Map<DateTime, bool> _meditasyonYapilanGunler;
//   DateTime _selectedDay = DateTime.now();
//   int _toplamGun = 0;
//   int _enUzunSeri = 0;
//   int _mevcutSeri = 0;
//   double _aylikBasariYuzdesi = 0.0;
//   List<String> _rozetler = [];
//   List<String> _oncekiRozetler = [];

//   @override
//   void initState() {
//     super.initState();
//     _meditasyonYapilanGunler = {};
//     _loadOncekiRozetler();
//     _loadData();
//   }

//   void _loadOncekiRozetler() async {
//     final prefs = await SharedPreferences.getInstance();
//     _oncekiRozetler = prefs.getStringList('kazanimlar') ?? [];
//   }

//   void _gosterTebrik({required String rozet}) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Stack(
//         children: [
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.5,
//               child: Lottie.asset(
//                 'assets/fireworks.json',
//                 repeat: false,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Center(
//             child: Container(
//               padding: EdgeInsets.all(24),
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.95),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.emoji_events, size: 100, color: Colors.amber),
//                   SizedBox(height: 16),
//                   Text(
//                     '🎉 Tebrikler!',
//                     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     '$rozet rozeti kazandınız!',
//                     style: TextStyle(fontSize: 20, color: Colors.black87),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                     child: Text('Harika!',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         )),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storedData = prefs.getString('meditasyon_gunleri');
//     if (storedData != null) {
//       Map<String, dynamic> decoded = json.decode(storedData);
//       _meditasyonYapilanGunler = decoded.map((key, value) =>
//           MapEntry(DateTime.parse(key), value as bool));
//     }
//     await _hesaplaIstatistikler();
//     setState(() {});
//   }

//   Future<void> _saveData() async {
//     final prefs = await SharedPreferences.getInstance();
//     Map<String, bool> stringKeyedMap = _meditasyonYapilanGunler.map(
//         (key, value) => MapEntry(key.toIso8601String(), value));
//     await prefs.setString('meditasyon_gunleri', json.encode(stringKeyedMap));
//   }

//  void _toggleMeditasyonYapildi(DateTime date) async {
//   final bool yeniDurum = !(_meditasyonYapilanGunler[date] ?? false);
//   _meditasyonYapilanGunler[date] = yeniDurum;
//   await _saveData();

//   final eskiRozetler = List<String>.from(_rozetler); 
//   await _hesaplaIstatistikler();


//   final yeniKazanimlar = _rozetler.where((r) => !eskiRozetler.contains(r)).toList();
//   if (yeniKazanimlar.isNotEmpty) {
//     _gosterTebrik(rozet: yeniKazanimlar.last);
//   }

//   setState(() {});
// }


// Future<void> _hesaplaIstatistikler() async {
//   final prefs = await SharedPreferences.getInstance();
//   final now = DateTime.now();
//   final ayBaslangici = DateTime(now.year, now.month, 1);
//   final aySonu = DateTime(now.year, now.month + 1, 0);
//   int ayToplamGun = aySonu.day;
//   int ayIcerisindeYapilanGun = 0;

//   List<DateTime> gunler = _meditasyonYapilanGunler.keys.toList();
//   gunler.sort();

//   _toplamGun = _meditasyonYapilanGunler.values.where((v) => v).length;

//   for (int i = 0; i < ayToplamGun; i++) {
//     DateTime gun = ayBaslangici.add(Duration(days: i));
//     if (_meditasyonYapilanGunler[gun] == true) {
//       ayIcerisindeYapilanGun++;
//     }
//   }
//   _aylikBasariYuzdesi = (ayIcerisindeYapilanGun / ayToplamGun) * 100;

//   _mevcutSeri = 0;
//   _enUzunSeri = 0;
//   int geciciSeri = 0;
//   DateTime? oncekiGun;

//   for (DateTime gun in gunler) {
//     if (_meditasyonYapilanGunler[gun] == true) {
//       if (oncekiGun != null && gun.difference(oncekiGun).inDays == 1) {
//         geciciSeri++;
//       } else {
//         geciciSeri = 1;
//       }
//       if (geciciSeri > _enUzunSeri) {
//         _enUzunSeri = geciciSeri;
//       }
//       oncekiGun = gun;
//     } else {
//       geciciSeri = 0;
//       oncekiGun = null;
//     }
//   }
//   _mevcutSeri = geciciSeri;

//   _rozetler = [];
//   if (_toplamGun >= 1) _rozetler.add("Başlangıç");
//   if (_toplamGun >= 7) _rozetler.add("1 Hafta");
//   if (_toplamGun >= 30) _rozetler.add("1 Ay");
//   if (_enUzunSeri >= 7) _rozetler.add("7 Günlük Seri");
//   if (_enUzunSeri >= 30) _rozetler.add("30 Günlük Seri");

//   List<String> yeniRozetler = _rozetler.where((r) => !_oncekiRozetler.contains(r)).toList();

//   if (yeniRozetler.isNotEmpty) {
//     await prefs.setStringList('kazanimlar', _rozetler);
//     _oncekiRozetler = List.from(_rozetler);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _gosterTebrik(rozet: yeniRozetler.last);
//     });
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Günlük Takip',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             )),
//         backgroundColor: Colors.teal,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//          automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TableCalendar(
//               focusedDay: _selectedDay,
//               locale: 'tr_TR',
//               firstDay: DateTime(2022),
//               lastDay: DateTime(2030),
//               calendarFormat: CalendarFormat.month,
//               selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                 });
//               },
//               calendarBuilders: CalendarBuilders(
//                 defaultBuilder: (context, day, focusedDay) {
//                   bool meditasyonYapildi = _meditasyonYapilanGunler[day] ?? false;
//                   return Container(
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: meditasyonYapildi ? Colors.teal : null,
//                     ),
//                     child: Text(
//                       '${day.day}',
//                       style: TextStyle(
//                         color: meditasyonYapildi ? Colors.white : null,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
                  
//                   onPressed: () => _toggleMeditasyonYapildi(_selectedDay),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.teal,
//                   ),
//                   child: Text(
//                     _meditasyonYapilanGunler[_selectedDay] == true
//                         ? 'İşareti Kaldır'
//                         : 'Bugünü İşaretle',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.calendar_today),
//               title: Text('Toplam Gün: $_toplamGun'),
//             ),
//             ListTile(
//               leading: Icon(Icons.local_fire_department),
//               title: Text('Mevcut Seri: $_mevcutSeri'),
//             ),
//             ListTile(
//               leading: Icon(Icons.emoji_events),
//               title: Text('En Uzun Seri: $_enUzunSeri'),
//             ),
//             ListTile(
//               leading: Icon(Icons.bar_chart),
//               title: Text('Aylık Başarı: ${_aylikBasariYuzdesi.toStringAsFixed(1)}%'),
//             ),
//             ListTile(
//               leading: Icon(Icons.military_tech),
//               title: Text('Rozetler: ${_rozetler.join(', ')}'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

class GunlukTakipSayfasi extends StatefulWidget {
  const GunlukTakipSayfasi({super.key});

  @override
  State<GunlukTakipSayfasi> createState() => _GunlukTakipSayfasiState();
}

class _GunlukTakipSayfasiState extends State<GunlukTakipSayfasi> {
  late Map<DateTime, bool> _meditasyonYapilanGunler;
  DateTime _selectedDay = DateTime.now();
  int _toplamGun = 0;
  int _enUzunSeri = 0;
  int _mevcutSeri = 0;
  double _aylikBasariYuzdesi = 0.0;
  List<String> _rozetler = [];
  List<String> _oncekiRozetler = [];

  @override
  void initState() {
    super.initState();
    _meditasyonYapilanGunler = {};
    _loadOncekiRozetler();
    _loadData();
  }

  void _loadOncekiRozetler() async {
    final prefs = await SharedPreferences.getInstance();
    _oncekiRozetler = prefs.getStringList('kazanimlar') ?? [];
  }

  void _gosterTebrik({required String rozet}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset('assets/fireworks.json', fit: BoxFit.cover),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, size: 100, color: Colors.amber),
                  SizedBox(height: 16),
                  Text('🎉 Tebrikler!',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('$rozet rozeti kazandınız!',
                      style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: Text('Harika!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('meditasyon_gunleri');
    if (storedData != null) {
      Map<String, dynamic> decoded = json.decode(storedData);
      _meditasyonYapilanGunler = decoded.map((key, value) =>
          MapEntry(DateTime.parse(key), value as bool));
    }
    await _hesaplaIstatistikler();
    setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, bool> stringKeyedMap = _meditasyonYapilanGunler.map(
        (key, value) => MapEntry(key.toIso8601String(), value));
    await prefs.setString('meditasyon_gunleri', json.encode(stringKeyedMap));
  }

  void _toggleMeditasyonYapildi(DateTime date) async {
    final bool yeniDurum = !(_meditasyonYapilanGunler[date] ?? false);
    _meditasyonYapilanGunler[date] = yeniDurum;
    await _saveData();
    final eskiRozetler = List<String>.from(_rozetler);
    await _hesaplaIstatistikler();
    final yeniKazanimlar =
        _rozetler.where((r) => !eskiRozetler.contains(r)).toList();
    if (yeniKazanimlar.isNotEmpty) {
      _gosterTebrik(rozet: yeniKazanimlar.last);
    }
    setState(() {});
  }

  Future<void> _hesaplaIstatistikler() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final ayBaslangici = DateTime(now.year, now.month, 1);
    final aySonu = DateTime(now.year, now.month + 1, 0);
    int ayToplamGun = aySonu.day;
    int ayIcerisindeYapilanGun = 0;

    List<DateTime> gunler = _meditasyonYapilanGunler.keys.toList()..sort();

    _toplamGun = _meditasyonYapilanGunler.values.where((v) => v).length;

    for (int i = 0; i < ayToplamGun; i++) {
      DateTime gun = ayBaslangici.add(Duration(days: i));
      if (_meditasyonYapilanGunler[gun] == true) {
        ayIcerisindeYapilanGun++;
      }
    }
    _aylikBasariYuzdesi = (ayIcerisindeYapilanGun / ayToplamGun) * 100;

    _mevcutSeri = 0;
    _enUzunSeri = 0;
    int geciciSeri = 0;
    DateTime? oncekiGun;

    for (DateTime gun in gunler) {
      if (_meditasyonYapilanGunler[gun] == true) {
        if (oncekiGun != null && gun.difference(oncekiGun).inDays == 1) {
          geciciSeri++;
        } else {
          geciciSeri = 1;
        }
        if (geciciSeri > _enUzunSeri) {
          _enUzunSeri = geciciSeri;
        }
        oncekiGun = gun;
      } else {
        geciciSeri = 0;
        oncekiGun = null;
      }
    }
    _mevcutSeri = geciciSeri;

    _rozetler = [];
    if (_toplamGun >= 1) _rozetler.add("Başlangıç");
    if (_toplamGun >= 7) _rozetler.add("1 Hafta");
    if (_toplamGun >= 30) _rozetler.add("1 Ay");
    if (_enUzunSeri >= 7) _rozetler.add("7 Günlük Seri");
    if (_enUzunSeri >= 30) _rozetler.add("30 Günlük Seri");

    List<String> yeniRozetler =
        _rozetler.where((r) => !_oncekiRozetler.contains(r)).toList();

    if (yeniRozetler.isNotEmpty) {
      await prefs.setStringList('kazanimlar', _rozetler);
      _oncekiRozetler = List.from(_rozetler);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('Günlük Takip',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    focusedDay: _selectedDay,
                    locale: 'tr_TR',
                    firstDay: DateTime(2022),
                    lastDay: DateTime(2030),
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                      });
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        bool meditasyonYapildi =
                            _meditasyonYapilanGunler[day] ?? false;
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: meditasyonYapildi ? Colors.teal : null,
                          ),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: meditasyonYapildi ? Colors.white : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _toggleMeditasyonYapildi(_selectedDay),
                icon: Icon(Icons.check_circle_outline),
                label: Text(
                  _meditasyonYapilanGunler[_selectedDay] == true
                      ? 'İşareti Kaldır'
                      : 'Bugünü İşaretle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              ),
              SizedBox(height: 20),
              Divider(),
              ..._buildInfoCards(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInfoCards() {
    final items = [
      {'title': 'Toplam Gün', 'value': _toplamGun, 'icon': Icons.calendar_today},
      {'title': 'Mevcut Seri', 'value': _mevcutSeri, 'icon': Icons.local_fire_department},
      {'title': 'En Uzun Seri', 'value': _enUzunSeri, 'icon': Icons.emoji_events},
      {
        'title': 'Aylık Başarı',
        'value': '${_aylikBasariYuzdesi.toStringAsFixed(1)}%',
        'icon': Icons.bar_chart
      },
      {
        'title': 'Rozetler',
        'value': _rozetler.join(', '),
        'icon': Icons.military_tech
      },
    ];

    return items.map((item) {
      return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(item['icon'] as IconData, color: Colors.teal, size: 30),
          title: Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          
            item['title'].toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          trailing: Text(
            maxLines: null,
            item['value'].toString(),
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
      );
    }).toList();
  }
}



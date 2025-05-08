

import 'dart:async';
import 'package:flutter/material.dart';

class NefesEgzersiziSayfasi extends StatefulWidget {
  const NefesEgzersiziSayfasi({super.key});

  @override
  State<NefesEgzersiziSayfasi> createState() => _NefesEgzersiziSayfasiState();
}

class _NefesEgzersiziSayfasiState extends State<NefesEgzersiziSayfasi>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _textTimer;
  Timer? _geriSayimTimer;
  int _geriSayim = 0;

  String _egzersizAsamasi = 'Hazır mısın?';

  final List<_EgzersizAdimi> _adimlar = [
    _EgzersizAdimi('Nefes Al', 4),
    _EgzersizAdimi('Tut', 4),
    _EgzersizAdimi('Nefes Ver', 4),
  ];

  int _currentAdimIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 120, end: 280).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _baslatEgzersiz();
  }

  void _baslatEgzersiz() {
    _yeniAdimiBaslat();
    _textTimer = Timer.periodic(Duration(seconds: 4), (_) {
      setState(() {
        _currentAdimIndex = (_currentAdimIndex + 1) % _adimlar.length;
      });
      _yeniAdimiBaslat();
    });
  }

  void _yeniAdimiBaslat() {
    final adim = _adimlar[_currentAdimIndex];
    setState(() {
      _egzersizAsamasi = adim.isim;
      _geriSayim = adim.saniye;
    });

    _tetikleAnimasyon(adim.isim);

    _geriSayimTimer?.cancel();
    _geriSayimTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_geriSayim <= 1) {
        timer.cancel();
      }
      setState(() {
        _geriSayim -= 1;
      });
    });
  }

  void _tetikleAnimasyon(String adim) {
    if (adim == 'Nefes Al') {
      _controller.forward();
    } else if (adim == 'Nefes Ver') {
      _controller.reverse();
    } else if (adim == 'Tut') {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textTimer?.cancel();
    _geriSayimTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text('Nefes Egzersizi',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _egzersizAsamasi,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),
                  ),
                  SizedBox(height: 8),
                  if (_geriSayim > 0)
                    Text(
                      '$_geriSayim saniye',
                      style: TextStyle(fontSize: 20, color: Colors.blue[600]),
                    ),
                  SizedBox(height: 30),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: _animation.value,
                        height: _animation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.blue.shade200,
                              Colors.blue.shade400,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EgzersizAdimi {
  final String isim;
  final int saniye;
  _EgzersizAdimi(this.isim, this.saniye);
}


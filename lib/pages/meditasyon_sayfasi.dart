

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MeditasyonSayfasi extends StatefulWidget {
  @override
  _MeditasyonSayfasiState createState() => _MeditasyonSayfasiState();
}

class _MeditasyonSayfasiState extends State<MeditasyonSayfasi> {
  final player = AudioPlayer();
  bool isPlaying = false;
  String? playingPath;

  final List<Map<String, String>> sesler = [
    {
      'baslik': 'Rahatlama Meditasyonu',
      'dosya': 'assets/sounds/meditasyon1.mp3',
    },
    {
      'baslik': 'Derin Nefes Meditasyonu',
      'dosya': 'assets/sounds/meditasyon2.mp3',
    },
    {
      'baslik': 'Odaklanma Meditasyonu',
      'dosya': 'assets/sounds/meditasyon3.mp3',
    },
      {
      'baslik': 'Yağmur Sesi Meditasyonu',
      'dosya': 'assets/sounds/meditasyon4.mp3',
    },
     {
      'baslik': 'Şömine Sesi Meditasyonu',
      'dosya': 'assets/sounds/meditasyon5.mp3',
    },
    {
      'baslik': 'Kuş Sesi Meditasyonu',
      'dosya': 'assets/sounds/meditasyon6.mp3',
    },
    
  ];

  void togglePlay(String dosyaYolu) async {
    try {
      if (isPlaying && playingPath == dosyaYolu) {
        await player.stop();
        setState(() {
          isPlaying = false;
          playingPath = null;
        });
      } else {
        await player.setAsset(dosyaYolu);
        player.play();
        setState(() {
          isPlaying = true;
          playingPath = dosyaYolu;
        });
      }
    } catch (e) {
      print("Ses oynatma hatası: $e");
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('Meditasyonlar',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade800, Colors.teal.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zihnini Dinlendir 🧘',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 12),
                Text(
                  'Bir meditasyon seç ve rahatlamaya başla.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: sesler.length,
                    itemBuilder: (context, index) {
                      final meditasyon = sesler[index];
                      final bool caliyorMu =
                          playingPath == meditasyon['dosya'] && isPlaying;
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          leading: Icon(Icons.self_improvement,
                              size: 32, color: Colors.teal),
                          title: Text(meditasyon['baslik']!,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          trailing: IconButton(
                            icon: Icon(
                                caliyorMu
                                    ? Icons.stop_circle
                                    : Icons.play_circle_fill,
                                size: 32),
                            onPressed: () => togglePlay(meditasyon['dosya']!),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

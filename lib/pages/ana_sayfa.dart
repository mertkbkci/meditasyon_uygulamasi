

import 'package:flutter/material.dart';

class AnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Sağlık & Meditasyon', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade700, Colors.teal.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Hoş Geldiniz 👋',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Bugün kendin için iyi bir şey yapmaya ne dersin?',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 24),
                _buildCard(
                  context,
                  title: '🧘 Meditasyonlar',
                  subtitle: 'Zihnini ve bedenini dinlendir',
                  route: '/meditasyon',
                ),
                _buildCard(
                  context,
                  title: '📆 Günlük Takip',
                  subtitle: 'İlerlemeni kontrol et',
                  route: '/gunluk',
                ),
                _buildCard(
                  context,
                  title: '🌬️ Nefes Egzersizi',
                  subtitle: 'Rahatlamak için nefes al',
                  route: '/nefes',
                ),
                _buildCard(
                  context,
                  title: '⚙️ Ayarlar',
                  subtitle: 'Bildirim ve tercihleri yönet',
                  route: '/ayarlar',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required String subtitle, required String route}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}


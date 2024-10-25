import 'package:flutter/material.dart';
import 'package:ulkeleri_tani/bottom_navigation_bar.dart';
import 'package:ulkeleri_tani/sag_oyun.dart';
import 'ana_sayfa.dart';
import 'hangisi_kalabalik.dart';
import 'orta_oyun.dart';

class SolOyun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Nüfuslar ve Bölgeler",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height, // Tüm ekran boyutunu al
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildGameCard(
                context,
                'assets/aa.jpg',
                Icons.people,
                "Hangi Ülke Daha Kalabalık Oyunu",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NufusKarsilastirmaOyunu()),
                  );
                },
              ),
              buildGameCard(
                context,
                'assets/bb.jpg',
                Icons.public,
                "Ülkeler Hangi Bölgede Oyunu",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YeniOyun()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        onHomePressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AnaSayfa()),
          );
        },
        onSagOyunPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SagOyun()),
          );
        },
        onSolOyunPressed: () {},
      ),
    );
  }

  Widget buildGameCard(
    BuildContext context,
    String imagePath,
    IconData icon,
    String title,
    VoidCallback onPressed,
  ) {
    // Dinamik kart yüksekliğini belirle
    double cardHeight = MediaQuery.of(context).size.height * 0.3; // Kartın yüksekliğini ekranın %30'u olarak ayarlıyoruz

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: cardHeight, // Dinamik yükseklik
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.yellowAccent[400]!.withOpacity(0.8),
                    shadows: [
                      Shadow(
                        blurRadius: 12.0,
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            blurRadius: 15.0,
                            color: Colors.black.withOpacity(0.6),
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30), // Butonun yukarısında daha fazla boşluk
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[800],
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.black.withOpacity(0.3),
                      elevation: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Oyunu Başlat",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

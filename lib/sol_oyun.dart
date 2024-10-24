import 'package:flutter/material.dart';
import 'package:ulkeleri_tani/orta_oyun.dart';
import 'bottom_navigation_bar.dart';
import 'ana_sayfa.dart';
import 'sag_oyun.dart';
import 'hangisi_kalabalik.dart';

class SolOyun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Nüfuslar ve Bölgeler",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        // Arka plana degrade ekliyoruz
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // İlk Container
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10), // Kenarlardan boşluk
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/aa.jpg'), // Arka plan resmi
                      fit: BoxFit.cover, // Resmin alanı kaplaması için
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.8), // Yarı saydam beyaz katman
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people, // Dünya ikonu
                          size: 100,
                          color: Colors.yellow,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Hangi Ülke Daha Kalabalık Oyunu",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NufusKarsilastirmaOyunu()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            backgroundColor: Colors.deepPurple[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10, // Butona gölge efekti
                            shadowColor: Colors.black26,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons
                                    .play_arrow, // Butonun soluna oyun başlat ikonu
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Oyunu Başlat",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // İkinci Container
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10), // Kenarlardan boşluk
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/bb.jpg'), // Arka plan resmi
                      fit: BoxFit.cover, // Resmin alanı kaplaması için
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.8), // Yarı saydam beyaz katman
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.public, // Dünya ikonu
                          size: 100,
                          color: Colors.yellow,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Ülkeler Hangi Bölgede", // İkinci oyunun başlığı
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YeniOyun()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            backgroundColor: Colors.deepPurple[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10, // Butona gölge efekti
                            shadowColor: Colors.black26,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons
                                    .play_arrow, // Butonun soluna oyun başlat ikonu
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Oyunu Başlat", // İkinci oyunun başlatma metni
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SagOyun()),
          );
        },
        onSolOyunPressed: () {},
      ),
    );
  }
}

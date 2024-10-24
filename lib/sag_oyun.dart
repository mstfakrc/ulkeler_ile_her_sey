import 'package:flutter/material.dart';
import 'package:ulkeleri_tani/baskent_bulma_oyunu.dart';
import 'package:ulkeleri_tani/bottom_navigation_bar.dart';
import 'package:ulkeleri_tani/dil_oyunu.dart';
import 'package:ulkeleri_tani/sol_oyun.dart';
import 'ana_sayfa.dart';

class SagOyun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Başkentler ve Diller",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 8,
        shadowColor: Colors.deepPurple.withOpacity(0.6),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/cc.jpg'), // Fotoğrafın yolu
                          fit: BoxFit.cover, // Resmi kaplamak için
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
                                Icons.flag_rounded,
                                size: 100,
                                color:
                                    Colors.yellowAccent[400]!.withOpacity(0.8),
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
                                  "Başkent Bulma Oyunu",
                                  style: TextStyle(
                                    fontSize: 38,
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
                              SizedBox(height: 50),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BaskentBulmaOyunu()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple[800],
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  textStyle: TextStyle(
                                    fontSize: 26,
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
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/dd.jpg'), // Fotoğrafın yolu
                          fit: BoxFit.cover, // Resmi kaplamak için
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
                                Icons.language,
                                size: 100,
                                color:
                                    Colors.yellowAccent[400]!.withOpacity(0.8),
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
                                  "Ülkeler Hangi Dili Konuşur",
                                  style: TextStyle(
                                    fontSize: 38,
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
                              SizedBox(height: 50),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YeniDil()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple[800],
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  textStyle: TextStyle(
                                    fontSize: 26,
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
        onSagOyunPressed: () {},
        onSolOyunPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SolOyun()),
          );
        },
      ),
    );
  }
}

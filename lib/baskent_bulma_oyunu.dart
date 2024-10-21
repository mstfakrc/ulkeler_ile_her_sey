import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulkeleri_tani/sag_oyun.dart';
import 'package:ulkeleri_tani/sol_oyun.dart';
import 'package:ulkeleri_tani/ulke.dart';
import 'package:ulkeleri_tani/bottom_navigation_bar.dart';
import 'ana_sayfa.dart';

class BaskentBulmaOyunu extends StatefulWidget {
  @override
  _BaskentBulmaOyunuState createState() => _BaskentBulmaOyunuState();
}

class _BaskentBulmaOyunuState extends State<BaskentBulmaOyunu> {
  final String _apiUrl =
      "https://restcountries.com/v3.1/all?fields=name,flags,cca2,capital";
  List<Ulke> _ulkeler = [];
  Ulke? _soruUlke;
  String _cevap = "";
  bool _dogruCevap = false;
  bool _cevapVerildi = false;
  final TextEditingController _cevapController =
      TextEditingController(); // Controller ekledik

  @override
  void initState() {
    super.initState();
    _ulkeleriYukle();
  }

  Future<void> _ulkeleriYukle() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> parsedResponse = jsonDecode(response.body);
      setState(() {
        _ulkeler =
            parsedResponse.map((ulkeMap) => Ulke.fromMap(ulkeMap)).toList();
        _rastgeleSoru();
      });
    } else {
      throw Exception('Veri yüklenirken bir hata oluştu');
    }
  }

  void _rastgeleSoru() {
    final random = Random();
    _soruUlke = _ulkeler[random.nextInt(_ulkeler.length)];
    _cevap = "";
    _cevapVerildi = false;
    _cevapController.clear(); // Metin kutusunu temizle
    setState(() {});
  }

  void _kontrolEt() {
    setState(() {
      _cevapVerildi = true;
      _dogruCevap = _cevap.trim().toLowerCase() ==
          _soruUlke!.baskent.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Başkent Bulma Oyunu"),
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
      ),
      body: _soruUlke == null
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
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
        onSolOyunPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SolOyun()),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      // Ekranı kaydırılabilir hale getirdik
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Genel boşluk ekledik
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  _soruUlke!.bayrak,
                  width: 200,
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(
                  _soruUlke!.isim, // Ülkenin ismini ekledik
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
                SizedBox(height: 20),
                Text(
                  "Başkentini tahmin et:",
                  style: TextStyle(fontSize: 24, color: Colors.black54),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _cevapController, // Controller'ı ekledik
                    onChanged: (value) {
                      _cevap = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Başkent",
                      labelStyle: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _cevapVerildi ? null : _kontrolEt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Kontrol Et",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                if (_cevapVerildi)
                  Column(
                    children: [
                      Icon(
                        _dogruCevap ? Icons.check_circle : Icons.cancel,
                        color: _dogruCevap ? Colors.green : Colors.red,
                        size: 48,
                      ),
                      SizedBox(height: 10),
                      Text(
                        _dogruCevap
                            ? "Doğru!"
                            : "Yanlış! Doğru cevap: ${_soruUlke!.baskent}",
                        style: TextStyle(fontSize: 24, color: Colors.black54),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _rastgeleSoru();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Yeni Soru",style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

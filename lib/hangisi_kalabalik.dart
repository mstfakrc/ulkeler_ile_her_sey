import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulkeleri_tani/sag_oyun.dart';
import 'package:ulkeleri_tani/sol_oyun.dart';
import 'package:ulkeleri_tani/ulke.dart';
import 'package:ulkeleri_tani/bottom_navigation_bar.dart';
import 'ana_sayfa.dart';

class NufusKarsilastirmaOyunu extends StatefulWidget {
  @override
  _NufusKarsilastirmaOyunuState createState() => _NufusKarsilastirmaOyunuState();
}

class _NufusKarsilastirmaOyunuState extends State<NufusKarsilastirmaOyunu> {
  final String _apiUrl = "https://restcountries.com/v3.1/all?fields=name,flags,cca2,population";
  List<Ulke> _ulkeler = [];
  Ulke? _ulke1;
  Ulke? _ulke2;
  bool _cevapVerildi = false;
  bool _dogruCevap = false;

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
        _ulkeler = parsedResponse.map((ulkeMap) => Ulke.fromMap(ulkeMap)).toList();
        _rastgeleSoru();
      });
    } else {
      throw Exception('Veri yüklenirken bir hata oluştu');
    }
  }

  void _rastgeleSoru() {
    final random = Random();
    _ulke1 = _ulkeler[random.nextInt(_ulkeler.length)];
    _ulke2 = _ulkeler[random.nextInt(_ulkeler.length)];
    while (_ulke1!.ulkeKodu == _ulke2!.ulkeKodu) {
      _ulke2 = _ulkeler[random.nextInt(_ulkeler.length)]; // Farklı ülkeler seçilmesi için döngü
    }
    _cevapVerildi = false; // Cevap durumunu sıfırla
    setState(() {});
  }

  void _kontrolEt(Ulke secilenUlke) {
  setState(() {
    _cevapVerildi = true;

    // Seçilen ülkenin nüfusunu kontrol et
    if (_ulke1!.nufus > _ulke2!.nufus) {
      // _ulke1 daha büyükse
      _dogruCevap = (secilenUlke == _ulke1);
    } else {
      // _ulke2 daha büyükse
      _dogruCevap = (secilenUlke == _ulke2);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Nüfus Karşılaştırma Oyunu"),
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
      ),
      body: _ulke1 == null || _ulke2 == null
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildUlkeCard(_ulke1!),
                    _buildUlkeCard(_ulke2!),
                  ],
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
                        _dogruCevap ? "Doğru!" : "Yanlış!",
                        style: TextStyle(fontSize: 24, color: Colors.black54),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Nüfuslar: ${_ulke1!.isim}: ${_ulke1!.nufus}, ${_ulke2!.isim}: ${_ulke2!.nufus}",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _rastgeleSoru,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Yeni Soru", style: TextStyle(color: Colors.black)),
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

  Widget _buildUlkeCard(Ulke ulke) {
    return GestureDetector(
      onTap: () => !_cevapVerildi ? _kontrolEt(ulke) : null,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              ulke.bayrak,
              width: 100,
              height: 60,
            ),
            SizedBox(height: 10),
            Text(
              ulke.isim,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

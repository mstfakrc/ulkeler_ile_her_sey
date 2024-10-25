import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulkeleri_tani/ulke.dart';

class NufusKarsilastirmaOyunu extends StatefulWidget {
  @override
  _NufusKarsilastirmaOyunuState createState() =>
      _NufusKarsilastirmaOyunuState();
}

class _NufusKarsilastirmaOyunuState extends State<NufusKarsilastirmaOyunu> {
  final String _apiUrl =
      "https://restcountries.com/v3.1/all?fields=name,flags,cca2,population";
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
    _ulke1 = _ulkeler[random.nextInt(_ulkeler.length)];
    _ulke2 = _ulkeler[random.nextInt(_ulkeler.length)];
    while (_ulke1!.ulkeKodu == _ulke2!.ulkeKodu) {
      _ulke2 = _ulkeler[random.nextInt(_ulkeler.length)];
    }
    _cevapVerildi = false;
    setState(() {});
  }

  void _kontrolEt(Ulke secilenUlke) {
    setState(() {
      _cevapVerildi = true;

      if (_ulke1!.nufus > _ulke2!.nufus) {
        _dogruCevap = (secilenUlke == _ulke1);
      } else {
        _dogruCevap = (secilenUlke == _ulke2);
      }
    });
  }

  void _showExplanation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Oyun Açıklaması"),
          content: Text("Bu oyunda iki ülkenin nüfusu karşılaştırılmaktadır ve "
              "en kalabalık olanı bulmaya çalışacaksınız.İyi Eğlenceler"),
          actions: [
            TextButton(
              child: Text("Tamam"),
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "HANGİ ÜLKE DAHA KALABALIK",
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showExplanation, // Açıklama butonuna tıklandığında
          ),
        ],
      ),
      body: _ulke1 == null || _ulke2 == null
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.purple],
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
                      size: 90,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _dogruCevap ? "Doğru!" : "Yanlış!",
                      style: TextStyle(fontSize: 48, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Nüfuslar: ${_ulke1!.isim}: ${_ulke1!.nufus}, ${_ulke2!.isim}: ${_ulke2!.nufus}",
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _rastgeleSoru,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: Text(
                        "Yeni Soru",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 35, // Yazı boyutunu büyüt

                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color:
                                  Colors.black.withOpacity(0.3), // Gölge rengi
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
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
        child: Container(
          // Kart genişliğini artırdık
          padding: EdgeInsets.all(10), // İçerik için padding
          child: Column(
            children: [
              // Bayrağın yüksekliğini artırdık ve sabit bir boyutta tutuyoruz
              Image.network(
                ulke.bayrak,
                width: 300, // Bayrak boyutunu artırdık
                height: 200,
                fit: BoxFit.contain, // Bayrak kesme ayarı
              ),
              SizedBox(height: 10),
              Text(
                ulke.isim,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold), // Font boyutunu artırdık
              ),
            ],
          ),
        ),
      ),
    );
  }
}

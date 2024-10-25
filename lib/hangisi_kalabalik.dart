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
              "en kalabalık olanı bulmaya çalışacaksınız. İyi Eğlenceler"),
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
            fontSize: MediaQuery.of(context).size.width * 0.1,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              if (_cevapVerildi)
                Column(
                  children: [
                    Icon(
                      _dogruCevap ? Icons.check_circle : Icons.cancel,
                      color: _dogruCevap ? Colors.green : Colors.red,
                      size: MediaQuery.of(context).size.width * 0.15,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      _dogruCevap ? "Doğru!" : "Yanlış!",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          color: Colors.black54),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      "Nüfuslar: ${_ulke1!.isim}: ${_ulke1!.nufus}, ${_ulke2!.isim}: ${_ulke2!.nufus}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: Colors.black),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    ElevatedButton(
                      onPressed: _rastgeleSoru,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                      child: Text(
                        "Yeni Soru",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.05, // Yazı boyutunu dinamik ayarlama
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.3), // Gölge rengi
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
          padding: EdgeInsets.all(10), // İçerik için padding
          child: Column(
            children: [
              Image.network(
                ulke.bayrak,
                width: MediaQuery.of(context).size.width * 0.4, // Dinamik bayrak boyutu
                height: MediaQuery.of(context).size.width * 0.25, // Dinamik bayrak yüksekliği
                fit: BoxFit.contain, // Bayrak kesme ayarı
              ),
              SizedBox(height: 10),
              Text(
                ulke.isim,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ), // Dinamik font boyutu
              ),
            ],
          ),
        ),
      ),
    );
  }
}

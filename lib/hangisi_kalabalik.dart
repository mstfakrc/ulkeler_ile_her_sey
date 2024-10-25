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
      _dogruCevap = (_ulke1!.nufus > _ulke2!.nufus)
          ? (secilenUlke == _ulke1)
          : (secilenUlke == _ulke2);
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
                Navigator.of(context).pop();
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
            fontSize: MediaQuery.of(context).size.width * 0.044,
          ),
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            color: Colors.white,
            onPressed: _showExplanation,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child: _buildUlkeCard(_ulke1!)),
                  SizedBox(width: 10),
                  Flexible(child: _buildUlkeCard(_ulke2!)),
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
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              _ulke1!.isim,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${_ulke1!.nufus}",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20), // Aradaki boşluğu ayarladık
                        Column(
                          children: [
                            Text(
                              _ulke2!.isim,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${_ulke2!.nufus}",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                        "Yeni Ülke",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.3),
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
        child: Column(
          children: [
            Image.network(
              ulke.bayrak,
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.22,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                ulke.isim,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulkeleri_tani/ulke.dart';

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
      TextEditingController();

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
    _cevapController.clear();
    setState(() {});
  }

  void _kontrolEt() {
    if (_cevap.trim().isEmpty) {
      // Kullanıcı herhangi bir şey yazmadıysa uyarı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lütfen başkenti girin."),
          backgroundColor: Colors.black,
        ),
      );
      return; // Fonksiyonu sonlandır
    }

    setState(() {
      _cevapVerildi = true;
      _dogruCevap = _cevap.trim().toLowerCase() == 
          _soruUlke!.baskent.trim().toLowerCase();
    });
  }

  void _gosterBilgilendirme() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Bilgilendirme"),
          content: Text(
            "Bu oyun, ülkelerin başkentini sorarak sizlere öğretmek ister. "
            "Doğru yanıtlarla ülkelerin başkentlerini öğrenirken eğlenebilirsiniz!",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Tamam"),
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
          "Başkent Bulma Oyunu",
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _gosterBilgilendirme,
          ),
        ],
      ),
      body: _soruUlke == null
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.red],
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
              Image.network(
                _soruUlke!.bayrak,
                width: 300,
                height: 150,
              ),
              SizedBox(height: 10),
              Text(
                _soruUlke!.isim,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              SizedBox(height: 20),
              Text(
                "Başkentini tahmin et:",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: TextField(
                    controller: _cevapController,
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
                      labelStyle: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Tahmininizi girin...",
                      hintStyle: TextStyle(
                        color: Colors.deepPurple.withOpacity(0.7),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.red, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (!_cevapVerildi) ...[
                ElevatedButton(
                  onPressed: _kontrolEt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24),
                    elevation: 8,
                    shadowColor: Colors.red.withOpacity(0.5),
                  ),
                  child: Text(
                    "Kontrol Et",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 20),
              if (_cevapVerildi) ...[
                Icon(
                  _dogruCevap ? Icons.check_circle : Icons.cancel,
                  color: _dogruCevap ? Colors.green : Colors.red,
                  size: 100,
                ),
                SizedBox(height: 10),
                Text(
                  _dogruCevap
                      ? "Doğru!"
                      : "Yanlış! Doğru cevap: ${_soruUlke!.baskent}",
                  style: TextStyle(fontSize: 24, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _rastgeleSoru();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.5),
                  ),
                  child: Text(
                    "Yeni Soru",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

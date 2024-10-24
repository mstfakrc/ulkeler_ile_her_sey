import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YeniDil extends StatefulWidget {
  @override
  _DilOyunState createState() => _DilOyunState();
}

class _DilOyunState extends State<YeniDil> with SingleTickerProviderStateMixin {
  final String _apiUrl = "https://restcountries.com/v3.1/all?fields=name,flags,languages";
  List<Ulke> _ulkeler = [];
  Ulke? _seciliUlke;
  bool _cevapVerildi = false;
  bool _dogruCevap = false;
  String _dogruDil = '';
  List<String> _secenekDiller = [];
  bool _animasyonOynat = false;
  late AnimationController _animasyonKontrol;

  @override
  void initState() {
    super.initState();
    _ulkeleriYukle();
    
    // Animasyon kontrolcüsü tanımlanıyor
    _animasyonKontrol = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animasyonKontrol.dispose();
    super.dispose();
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
    _seciliUlke = _ulkeler[random.nextInt(_ulkeler.length)];
    _cevapVerildi = false;
    
    // Ülkenin dillerini al
    Map<String, dynamic> diller = _seciliUlke!.diller;

    // Doğru dili seç
    _dogruDil = diller.values.first; 

    // Maksimum 10 adet dil seçeneği oluştur
    List<String>? tumDiller = _ulkeler.expand((ulke) => ulke.diller.values).toSet().cast<String>().toList();
    tumDiller!.shuffle();
    _secenekDiller = tumDiller.take(9).toList();
    
    // Doğru cevabı da seçeneklere ekle
    _secenekDiller.add(_dogruDil);
    _secenekDiller.shuffle(); // Seçenekleri karıştır
    
    // Animasyonun sıfırlanması ve tekrar başlaması
    setState(() {
      _animasyonOynat = false; // Animasyonu sıfırlıyoruz
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _animasyonOynat = true; // Animasyonu tekrar başlatıyoruz
        _animasyonKontrol.forward(from: 0); // Animasyonu en baştan oynat
      });
    });
  }

  void _kontrolEt(String secilenDil) {
    setState(() {
      _cevapVerildi = true;
      _dogruCevap = (secilenDil == _dogruDil);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Hangi Ülke Hangi Dili Konuşur?"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _seciliUlke == null
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
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
                _buildUlkeCard(_seciliUlke!),
                SizedBox(height: 20),
                if (_cevapVerildi)
                  Column(
                    children: [
                      FadeTransition(
                        opacity: _animasyonKontrol,
                        child: Icon(
                          _dogruCevap ? Icons.check_circle : Icons.cancel,
                          color: _dogruCevap ? Colors.green : Colors.red,
                          size: 48,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _dogruCevap ? "Doğru!" : "Yanlış!",
                        style: TextStyle(fontSize: 24, color: Colors.black54),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Doğru Dil: $_dogruDil",
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
                        child: Text("Yeni Ülke", style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Text(
                  "Dili Seçin:",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _buildDilButtons(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUlkeCard(Ulke ulke) {
    return Card(
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
    );
  }

  List<Widget> _buildDilButtons() {
    return _secenekDiller.map((dil) {
      return ElevatedButton(
        onPressed: _cevapVerildi ? null : () {
          _kontrolEt(dil);
        },
        child: Text(dil),
      );
    }).toList();
  }
}

class Ulke {
  final String isim;
  final String bayrak;
  final Map<String, dynamic> diller;

  Ulke({required this.isim, required this.bayrak, required this.diller});

  factory Ulke.fromMap(Map<String, dynamic> map) {
    return Ulke(
      isim: map['name']['common'],
      bayrak: map['flags']['png'],
      diller: Map<String, dynamic>.from(map['languages']),
    );
  }
}

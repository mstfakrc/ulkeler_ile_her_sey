import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YeniDil extends StatefulWidget {
  @override
  _DilOyunState createState() => _DilOyunState();
}

class _DilOyunState extends State<YeniDil> with SingleTickerProviderStateMixin {
  final String _apiUrl =
      "https://restcountries.com/v3.1/all?fields=name,flags,languages";
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
    _seciliUlke = _ulkeler[random.nextInt(_ulkeler.length)];
    _cevapVerildi = false;
    Map<String, dynamic> diller = _seciliUlke!.diller;
    _dogruDil = diller.values.first;
    List<String>? tumDiller = _ulkeler
        .expand((ulke) => ulke.diller.values)
        .toSet()
        .cast<String>()
        .toList();
    tumDiller!.shuffle();
    _secenekDiller = tumDiller.take(9).toList();
    _secenekDiller.add(_dogruDil);
    _secenekDiller.shuffle();

    setState(() {
      _animasyonOynat = false;
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _animasyonOynat = true;
        _animasyonKontrol.forward(from: 0);
      });
    });
  }

  void _kontrolEt(String secilenDil) {
    setState(() {
      _cevapVerildi = true;
      _dogruCevap = (secilenDil == _dogruDil);
      _secenekDiller.clear(); // Cevap verildikten sonra seçenekleri gizle
    });
  }

  void _bilgiGoster() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bilgi"),
          content: Text(
              "Bu oyun, ülkelerin hangi dili konuştuklarını sorar. İyi eğlenceler!"),
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
          "Hangi Ülke Hangi Dili Konuşur?",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: _bilgiGoster,
          ),
        ],
      ),
      body: _seciliUlke == null
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUlkeCard(_seciliUlke!),
              SizedBox(height: 15),
              Text(
                "Dili Seçin:",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              SizedBox(height: 15),
              if (!_cevapVerildi)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _buildDilButtons(),
                ),
              if (_cevapVerildi)
                Column(
                  children: [
                    SizedBox(height: 30),
                    FadeTransition(
                      opacity: _animasyonKontrol,
                      child: Icon(
                        _dogruCevap ? Icons.check_circle : Icons.cancel,
                        color: _dogruCevap ? Colors.green : Colors.red,
                        size: 100,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _dogruCevap ? "Doğru!" : "Yanlış!",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Doğru Dil: $_dogruDil",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _rastgeleSoru,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Yeni Ülke",
                          style: TextStyle(color: Colors.black,fontSize: 25)),
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
    return Card(
      elevation: 8,
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ulke.bayrak,
                width: 160, // Bayrak boyutu ayarlandı
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Text(
              ulke.isim,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDilButtons() {
    return _secenekDiller.map((dil) {
      return SizedBox(
        width: MediaQuery.of(context).size.width *
            0.4, // Buton genişliği, ekran boyutuna göre ayarlandı
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10),
            backgroundColor: Colors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _cevapVerildi
              ? null
              : () {
                  _kontrolEt(dil);
                },
          child: Text(
            dil,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
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

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YeniDil extends StatefulWidget {
  @override
  _DilOyunState createState() => _DilOyunState();
}

class _DilOyunState extends State<YeniDil> {
  final String _apiUrl = "https://restcountries.com/v3.1/all?fields=name,flags,languages";
  List<Ulke> _ulkeler = [];
  Ulke? _seciliUlke;
  bool _cevapVerildi = false;
  bool _dogruCevap = false;
  String _dogruDil = '';
  List<String> _secenekDiller = [];

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
    _seciliUlke = _ulkeler[random.nextInt(_ulkeler.length)];
    _cevapVerildi = false;
    Map<String, dynamic> diller = _seciliUlke!.diller;
    _dogruDil = diller.values.first;
    List<String>? tumDiller = _ulkeler.expand((ulke) => ulke.diller.values).toSet().cast<String>().toList();
    tumDiller.shuffle();
    _secenekDiller = tumDiller.take(11).toList();
    _secenekDiller.add(_dogruDil);
    _secenekDiller.shuffle();

    setState(() {});
  }

  void _kontrolEt(String secilenDil) {
    setState(() {
      _cevapVerildi = true;
      _dogruCevap = (secilenDil == _dogruDil);
    });
  }

  void _bilgiGoster() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bilgi"),
          content: Text("Bu oyun, ülkelerin hangi dili konuştuklarını sorar. İyi eğlenceler!"),
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
          "Hangi Ülke Hangi Dili Konuşur",
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045,fontWeight: FontWeight.bold),
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
      width: double.infinity,
      height: double.infinity,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                "Dili Seçin:",
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              if (!_cevapVerildi) _buildDilSecenekleri(),
              if (_cevapVerildi) _buildCevapEkrani(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDilSecenekleri() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _secenekDiller.map((dil) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.28,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10),
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (!_cevapVerildi) {
                _kontrolEt(dil);
              }
            },
            child: Text(
              dil,
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCevapEkrani() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Icon(
          _dogruCevap ? Icons.check_circle : Icons.cancel,
          color: _dogruCevap ? Colors.green : Colors.red,
          size: MediaQuery.of(context).size.width * 0.2,
        ),
        if (!_dogruCevap) ...[
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            "Doğru Dil: $_dogruDil",
            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.white),
          ),
        ],
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        ElevatedButton(
          onPressed: _rastgeleSoru,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Yeni Ülke",
            style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.06),
          ),
        ),
      ],
    );
  }

  Widget _buildUlkeCard(Ulke ulke) {
    return Card(
      elevation: 6,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ulke.bayrak,
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.15,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Text(
              ulke.isim,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
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

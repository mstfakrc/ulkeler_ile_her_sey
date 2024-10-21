import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulkeleri_tani/bottom_navigation_bar.dart';
import 'package:ulkeleri_tani/ana_sayfa.dart';
import 'package:ulkeleri_tani/sol_oyun.dart';
import 'package:ulkeleri_tani/sag_oyun.dart';
import 'package:ulkeleri_tani/ulke.dart';

class YeniDil extends StatefulWidget {
  @override
  _YeniDilState createState() => _YeniDilState();
}

class _YeniDilState extends State<YeniDil> {
  final String _apiUrl = "https://restcountries.com/v3.1/all?fields=name,flags,languages";
  List<Ulke> _ulkeler = [];
  Ulke? _seciliUlke;
  bool _cevapVerildi = false;
  bool _dogruCevap = false;
  String _dogruDil = '';

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
    _cevapVerildi = false; // Cevap durumunu sıfırla
    _dogruDil = _seciliUlke!.diller.first; // Doğru dili sakla
    setState(() {});
  }

  void _kontrolEt(String secilenDil) {
    setState(() {
      _cevapVerildi = true;
      // Seçilen dilin doğru olup olmadığını kontrol et
      _dogruCevap = (secilenDil.toLowerCase() == _dogruDil.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dil Bilgisi Oyunu"),
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
      ),
      body: _seciliUlke == null
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
                _buildUlkeCard(_seciliUlke!),
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
                // Ülkelerin dilleri için düğmeler
                Text(
                  "Dili Seçin:",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    // Ülkelere özgü dilleri dinamik olarak düğme olarak oluşturma
    final List<String> diller = _seciliUlke!.diller.toList(); // Seçilen ülkenin dilleri
    return diller.map((dil) {
      return ElevatedButton(
        onPressed: () {
          _kontrolEt(dil);
        },
        child: Text(dil),
      );
    }).toList();
  }
}
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulkeleri_tani/ulke.dart';

class YeniOyun extends StatefulWidget {
  @override
  _YeniOyunState createState() => _YeniOyunState();
}

class _YeniOyunState extends State<YeniOyun> {
  final String _apiUrl =
      "https://restcountries.com/v3.1/all?fields=name,flags,cca2,population,region";
  List<Ulke> _ulkeler = [];
  Ulke? _seciliUlke;
  bool _cevapVerildi = false;
  bool _dogruCevap = false;
  String _dogruBolge = '';
  bool _bolgeSecildi = false; // Bölge seçilip seçilmediğini kontrol etmek için

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
    _seciliUlke = _ulkeler[random.nextInt(_ulkeler.length)];
    _cevapVerildi = false; // Cevap durumunu sıfırla
    _dogruBolge = _seciliUlke!.bolge; // Doğru bölgeyi sakla
    _bolgeSecildi = false; // Bölge seçimini sıfırla
    setState(() {});
  }

  void _kontrolEt(String secilenBolge) {
    setState(() {
      _cevapVerildi = true;
      _bolgeSecildi = true; // Bölge seçildi
      // Seçilen bölgenin doğru olup olmadığını kontrol et
      _dogruCevap = (secilenBolge == _dogruBolge);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Hangi Ülke Nerede"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _seciliUlke == null
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.lightBlueAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
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
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Icon(
                          _dogruCevap ? Icons.check_circle : Icons.cancel,
                          key: ValueKey<bool>(_dogruCevap),
                          color: _dogruCevap ? Colors.green : Colors.red,
                          size: 64,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _dogruCevap ? "Doğru!" : "Yanlış!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Doğru Bölge: $_dogruBolge",
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle:
                              TextStyle(fontSize: 18), // Buton yazı boyutu
                        ),
                        child: Text("Yeni Ülke",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                // Ülkelerin bölgeleri için düğmeler
                if (!_bolgeSecildi) // Bölge seçildiğinde düğmeleri gizle
                  Column(
                    children: [
                      Text(
                        "Bölgeyi Seçin:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        children: _buildBolgeButtons(),
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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBolgeButtons() {
    // Ülkelere özgü bölgeleri dinamik olarak düğme olarak oluşturma
    final List<String> bolgeler =
        _ulkeler.map((ulke) => ulke.bolge).toSet().toList(); // Tekil bölgeler
    return bolgeler.map((bolge) {
      return ElevatedButton(
        onPressed: () {
          _kontrolEt(bolge);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          bolge,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }).toList();
  }
}

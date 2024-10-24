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
  bool _bolgeSecildi = false;

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
    _cevapVerildi = false;
    _dogruBolge = _seciliUlke!.bolge;
    _bolgeSecildi = false;
    setState(() {});
  }

  void _kontrolEt(String secilenBolge) {
    setState(() {
      _cevapVerildi = true;
      _bolgeSecildi = true;
      _dogruCevap = (secilenBolge == _dogruBolge);
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Oyun Bilgisi"),
          content: Text(
            "Bu oyun, ülkelerin hangi kıtada olduğunu öğrenmenizi sağlamaktadır.İyi Eğlenceler ",
            textAlign: TextAlign.justify,
          ),
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
          "Ülkeler Hangi Bölgede",
          style: TextStyle(fontSize: 40),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
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
      width: double.infinity, // Ekranı tam kaplama
      height: double.infinity, // Ekranı tam kaplama
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.green],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildUlkeCard(_seciliUlke!)),
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
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Doğru Bölge: $_dogruBolge",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _rastgeleSoru,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child:
                      Text("Yeni Ülke", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          SizedBox(height: 10),
          if (!_bolgeSecildi)
            Column(
              children: [
                Text(
                  "Bölgeyi Seçin:",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: _buildBolgeButtons(),
                ),
              ],
            ),
          SizedBox(height: 30), // Daha fazla alan bırakmak için
        ],
      ),
    );
  }

  Widget _buildUlkeCard(Ulke ulke) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: MediaQuery.of(context).size.width *
              0.4, // Ekranın %40'ı kadar genişlik
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                ulke.bayrak,
                width: MediaQuery.of(context).size.width *
                    0.4, // Kartla aynı genişlikte
                height: 250, // Bayrağın yüksekliği
                fit: BoxFit.cover,
              ),
              Text(
                ulke.isim,
                style: TextStyle(
                  fontSize: 20, // Daha küçük font boyutu
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBolgeButtons() {
    final List<String> bolgeler =
        _ulkeler.map((ulke) => ulke.bolge).toSet().toList();
    return bolgeler.map((bolge) {
      return ElevatedButton(
        onPressed: () {
          _kontrolEt(bolge);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Text(
          bolge,
          style: TextStyle(
              color: Colors.black,
              fontSize: 18), // Buton yazı boyutunu büyüttük
        ),
      );
    }).toList();
  }
}

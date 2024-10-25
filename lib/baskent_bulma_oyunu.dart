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
  final TextEditingController _cevapController = TextEditingController();
  double _bayrakBoyutu = 0.30; // Bayrak boyutu için başlangıç değeri

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
    _bayrakBoyutu = 0.25; // Bayrak boyutunu sıfırla
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

      // Bayrak boyutunu yalnızca cevap kontrol edildikten sonra değiştir
      _bayrakBoyutu = _dogruCevap ? 0.2 : 0.15; // Doğruysa biraz küçültebiliriz
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
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05), // Dinamik font boyutu
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
                width: MediaQuery.of(context).size.width * _bayrakBoyutu, // Dinamik bayrak boyutu
                height: MediaQuery.of(context).size.height * _bayrakBoyutu, // Dinamik bayrak boyutu
                fit: BoxFit.cover, // Resmi kapsayacak şekilde ayarla
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Dinamik boşluk
              Text(
                _soruUlke!.isim,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06, // Dinamik font boyutu
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
                textAlign: TextAlign.center, // Merkeze hizala
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Dinamik boşluk
              Text(
                "Başkentini tahmin et:",
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, color: Colors.black), // Dinamik font boyutu
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Dinamik boşluk
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75, // Ekranın %75'i kadar genişlik
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
                        vertical: MediaQuery.of(context).size.height * 0.025, // Dinamik iç boşluk
                        horizontal: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Dinamik boşluk
              if (!_cevapVerildi) ...[
                ElevatedButton(
                  onPressed: _kontrolEt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.025, // Dinamik buton yüksekliği
                        horizontal: MediaQuery.of(context).size.width * 0.1), // Dinamik buton genişliği
                    elevation: 8,
                    shadowColor: Colors.red.withOpacity(0.5),
                  ),
                  child: Text(
                    "Kontrol Et",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.045, // Dinamik font boyutu
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Dinamik boşluk
              if (_cevapVerildi) ...[
                Icon(
                  _dogruCevap ? Icons.check_circle : Icons.cancel,
                  color: _dogruCevap ? Colors.green : Colors.red,
                  size: MediaQuery.of(context).size.width * 0.2, // Dinamik ikon boyutu
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Dinamik boşluk
                Text(
                  _dogruCevap
                      ? "Doğru! Başkent: ${_soruUlke!.baskent}"
                      : "Yanlış! Doğru başkent: ${_soruUlke!.baskent}",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045, // Dinamik font boyutu
                    fontWeight: FontWeight.bold,
                    color: _dogruCevap ? Colors.black : Colors.black,
                  ),
                  textAlign: TextAlign.center, // Merkeze hizala
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Dinamik boşluk
                ElevatedButton(
                  onPressed: _rastgeleSoru,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.025, // Dinamik buton yüksekliği
                        horizontal: MediaQuery.of(context).size.width * 0.1), // Dinamik buton genişliği
                    elevation: 8,
                    shadowColor: Colors.red.withOpacity(0.5),
                  ),
                  child: Text(
                    "Yeni Soru",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.045, // Dinamik font boyutu
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

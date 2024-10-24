import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulkeleri_tani/favoriler.dart';
import 'package:ulkeleri_tani/ortak_liste.dart';
import 'package:ulkeleri_tani/sag_oyun.dart';
import 'package:ulkeleri_tani/sol_oyun.dart';
import 'package:ulkeleri_tani/ulke.dart';
import 'package:http/http.dart' as http;
import 'bottom_navigation_bar.dart';

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final String _apiUrl =
      "https://restcountries.com/v3.1/all?fields=name,flags,cca2,capital,region,languages,population";

  List<Ulke> _butunUlkeler = [];
  List<String> _favoriUlkeKodlari = [];
  List<Ulke> _aramaSonuclari = [];
  TextEditingController _aramaController = TextEditingController();
  FocusNode _aramaFocusNode = FocusNode(); // FocusNode tanımı
  bool _aramaAktif = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _favorileriCihazHafizasindanCek().then((value) {
        _ulkeleriInternettenCek();
        if (_aramaAktif) {
          FocusScope.of(context)
              .requestFocus(_aramaFocusNode); // Arama açıldığında odaklan
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: _aramaAktif
          ? TextField(
              controller: _aramaController,
              decoration: InputDecoration(
                hintText: "Ülke Ara...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _aramaSonuclari = _butunUlkeler.where((ulke) {
                  return ulke.isim.toLowerCase().contains(value.toLowerCase());
                }).toList();
                setState(() {});
              },
            )
          : Text(
              "Tüm Ülkeler",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
      centerTitle: true,
      backgroundColor: Colors.deepPurpleAccent,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: ClipOval(
          child: Container(
            width: 35, // Çemberin genişliği
            height: 35, // Çemberin yüksekliği
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/ulkeler.png"), // Resim yolunu buraya yazın
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _aramaAktif ? Icons.clear : Icons.search,
            color: Colors.yellow,
          ),
          onPressed: () {
            setState(() {
              _aramaAktif = !_aramaAktif; // Arama durumu değiştir
              if (!_aramaAktif) {
                _aramaController.clear(); // Arama çubuğu temizlensin
                _aramaSonuclari.clear(); // Arama sonuçları temizlensin
              }
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          onPressed: () {
            _favorilerSayfasiniAc(context);
          },
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent.withOpacity(0.5), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: _butunUlkeler.isEmpty
          ? Center(child: CircularProgressIndicator())
          : OrtakListe(
              _aramaAktif
                  ? _aramaSonuclari
                  : _butunUlkeler, // Arama durumuna göre liste
              _favoriUlkeKodlari,
            ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomNavBar(
      onHomePressed: () {
        // Ana sayfaya geçişte değişiklik yok
      },
      onSagOyunPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SagOyun()),
        );
      },
      onSolOyunPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SolOyun()),
        );
      },
    );
  }

  void _ulkeleriInternettenCek() async {
    Uri uri = Uri.parse(_apiUrl);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> parsedResponse = jsonDecode(response.body);

      for (var ulkeMap in parsedResponse) {
        Ulke ulke = Ulke.fromMap(ulkeMap);
        _butunUlkeler.add(ulke);
      }

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ülkeleri yüklerken bir hata oluştu."),
        ),
      );
    }
  }

  Future<void> _favorileriCihazHafizasindanCek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? favoriler = prefs.getStringList("favoriler");

    if (favoriler != null) {
      _favoriUlkeKodlari.addAll(favoriler);
    }
  }

  void _favorilerSayfasiniAc(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Favoriler(_butunUlkeler, _favoriUlkeKodlari);
        },
      ),
    );
  }

  @override
  void dispose() {
    _aramaController.dispose();
    _aramaFocusNode.dispose(); // FocusNode temizlenmesi
    super.dispose();
  }
}

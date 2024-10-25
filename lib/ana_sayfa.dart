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
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/ulkeler.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Center(
              // Metni ortalamak için Center widget'ı ekledik
              child: Text(
                "KÜRESEL KEŞİF",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width *
                      0.04, // Dinamik font boyutu
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
      centerTitle: false,
      backgroundColor: Colors.purple,
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Bilgilendirme"),
                  content: Text(
                    "Bu uygulama size dünyadaki ülkeler hakkında bilgi vermektedir.",
                  ),
                  actions: [
                    TextButton(
                      child: Text("Kapat"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(_aramaAktif ? Icons.clear : Icons.search,
              color: Colors.white),
          onPressed: () {
            setState(() {
              _aramaAktif = !_aramaAktif;
              if (!_aramaAktif) {
                _aramaController.clear();
                _aramaSonuclari.clear();
              }
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
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
          colors: [Colors.white, Colors.purple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          _aramaAktif
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _aramaController,
                    focusNode: _aramaFocusNode,
                    decoration: InputDecoration(
                      hintText: "Ülke adıyla arayın...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: _aramaYap, // Arama işlevi burada çağrılır
                  ),
                )
              : Container(),
          Expanded(
            child: _butunUlkeler.isEmpty
                ? Center(child: CircularProgressIndicator())
                : OrtakListe(
                    _aramaAktif ? _aramaSonuclari : _butunUlkeler,
                    _favoriUlkeKodlari,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomNavBar(
      onHomePressed: () {},
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

  void _aramaYap(String query) {
    setState(() {
      _aramaSonuclari = _butunUlkeler
          .where(
              (ulke) => ulke.isim.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _ulkeleriInternettenCek() async {
    Uri uri = Uri.parse(_apiUrl);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> parsedResponse = jsonDecode(response.body);

      setState(() {
        _butunUlkeler =
            parsedResponse.map((ulkeMap) => Ulke.fromMap(ulkeMap)).toList();
      });
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
      setState(() {
        _favoriUlkeKodlari.addAll(favoriler);
      });
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
    _aramaFocusNode.dispose();
    super.dispose();
  }
}

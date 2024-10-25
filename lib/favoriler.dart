import 'package:flutter/material.dart';
import 'package:ulkeleri_tani/ortak_liste.dart';
import 'package:ulkeleri_tani/ulke.dart';

class Favoriler extends StatefulWidget {
  final List<Ulke> _butunUlkeler;
  final List<String> _favoriUlkeKodlari;

  Favoriler(this._butunUlkeler, this._favoriUlkeKodlari);

  @override
  State<Favoriler> createState() => _FavorilerState();
}

class _FavorilerState extends State<Favoriler> {
  List<Ulke> _favoriUlkeler = [];
  String _aramaMetni = "";

  @override
  void initState() {
    super.initState();
    _favoriUlkeler = widget._butunUlkeler.where((ulke) => widget._favoriUlkeKodlari.contains(ulke.ulkeKodu)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(), // Arama çubuğunu ekliyoruz
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        "Favoriler",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.deepPurpleAccent, // Daha uyumlu bir renk
      elevation: 4, // Hafif gölge efekti
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            _showInfoDialog();
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _aramaMetni = value;
          });
        },
        decoration: InputDecoration(
          hintText: "Ülke adını girin",
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final filteredUlkeler = _favoriUlkeler.where((ulke) => ulke.isim.toLowerCase().contains(_aramaMetni.toLowerCase())).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent.withOpacity(0.5), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(16.0), // Padding ekle
      child: filteredUlkeler.isNotEmpty
          ? OrtakListe(filteredUlkeler, widget._favoriUlkeKodlari)
          : Center(
              child: Text(
                "Favori ülkeniz yok!",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Açıklama"),
          content: Text("Buradaki ülkeler favori olarak seçtiğiniz ülkelerdir."),
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
}

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

  @override
  void initState() {
    super.initState();
    for (Ulke ulke in widget._butunUlkeler) {
      if (widget._favoriUlkeKodlari.contains(ulke.ulkeKodu)) {
        _favoriUlkeler.add(ulke);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Favoriler", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.deepPurpleAccent, // Daha uyumlu bir renk
      elevation: 4, // Hafif gölge efekti
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
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding ekle
        child: _favoriUlkeler.isNotEmpty
            ? OrtakListe(_favoriUlkeler, widget._favoriUlkeKodlari)
            : Center(
                child: Text(
                  "Favori ülkeniz yok!",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
              ),
      ),
    );
  }
}

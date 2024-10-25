import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulkeleri_tani/ulke.dart';
import 'package:ulkeleri_tani/ulke_detay_sayfasi.dart';

class OrtakListe extends StatefulWidget {
  List<Ulke> _ulkeler = [];
  List<String> _favoriUlkeKodlari = [];

  OrtakListe(this._ulkeler, this._favoriUlkeKodlari);

  @override
  State<OrtakListe> createState() => _OrtakListeState();
}

class _OrtakListeState extends State<OrtakListe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ülkeler Listesi'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget._ulkeler.length,
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    Ulke ulke = widget._ulkeler[index];

    return Card(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      child: ListTile(
        title: Text(
          ulke.isim,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05, // Font boyutu dinamik
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Başkent: ${ulke.baskent}",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04, // Font boyutu dinamik
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(ulke.bayrak),
          radius: MediaQuery.of(context).size.width * 0.1, // Dinamik yarıçap
        ),
        trailing: IconButton(
          icon: Icon(
            widget._favoriUlkeKodlari.contains(ulke.ulkeKodu)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            _favoriTiklandi(ulke);
          },
        ),
        onTap: () {
          _ulkeTiklandi(context, ulke);
        },
      ),
    );
  }

  void _ulkeTiklandi(BuildContext context, Ulke ulke) {
    MaterialPageRoute sayfaYolu = MaterialPageRoute(
      builder: (context) {
        return UlkeDetaySayfasi(ulke);
      },
    );
    Navigator.push(context, sayfaYolu);
  }

  void _favoriTiklandi(Ulke ulke) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (widget._favoriUlkeKodlari.contains(ulke.ulkeKodu)) {
      widget._favoriUlkeKodlari.remove(ulke.ulkeKodu);
    } else {
      widget._favoriUlkeKodlari.add(ulke.ulkeKodu);
    }

    await prefs.setStringList("favoriler", widget._favoriUlkeKodlari);

    setState(() {});
  }
}

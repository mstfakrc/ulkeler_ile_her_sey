import 'package:flutter/material.dart';
import 'package:ulkeleri_tani/ulke.dart';

class UlkeDetaySayfasi extends StatelessWidget {
  final Ulke _ulke;

  UlkeDetaySayfasi(this._ulke);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlueAccent,
      elevation: 0,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildBayrak(context),
            SizedBox(height: 16),
            _buildUlkeIsmiText(),
            SizedBox(height: 24),
            _buildTumDetaylar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTumDetaylar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              _buildDetayRow("Ülke İsmi: ", _ulke.isim),
              Divider(),
              _buildDetayRow("Başkent: ", _ulke.baskent),
              Divider(),
              _buildDetayRow("Bölge: ", _ulke.bolge),
              Divider(),
              _buildDetayRow("Nüfus: ", _ulke.nufus.toString()),
              Divider(),
              _buildDetayRow("Dil: ", _ulke.dil),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBayrak(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          _ulke.bayrak,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUlkeIsmiText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        _ulke.isim,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }

  Widget _buildDetayRow(String baslik, String detay) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            baslik,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            detay,
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

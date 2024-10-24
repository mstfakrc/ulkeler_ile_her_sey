import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onSagOyunPressed;
  final VoidCallback onSolOyunPressed;

  const BottomNavBar({
    Key? key,
    required this.onHomePressed,
    required this.onSagOyunPressed,
    required this.onSolOyunPressed,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 1; // Varsayılan olarak "Ana Sayfa" seçili

  void handleButtonPress(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index; // Tıklanan düğmenin indeksi kaydediliyor
      });

      // Seçilen düğmeye göre ilgili fonksiyon çağrılıyor
      switch (index) {
        case 0:
          widget.onSolOyunPressed();
          break;
        case 1:
          widget.onHomePressed();
          break;
        case 2:
          widget.onSagOyunPressed();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomAppBar(
          color: Colors.purple, // Alt navigasyon arka planı
          elevation: 10, // Gölgeli görünüm için
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceAround, // İkonları eşit aralıkla yerleştir
            children: [
              _buildIconButton(Icons.star, 0), // "Sol Oyun" butonu
              _buildIconButton(Icons.home, 1), // "Ana Sayfa" butonu
              _buildIconButton(Icons.flag, 2), // "Sağ Oyun" butonu
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedIndex == index
            ? Colors.yellow
            : Colors.white, // Seçiliyse sarı
        size: 30, // İkon boyutu
      ),
      onPressed: () => handleButtonPress(index),
    );
  }
}

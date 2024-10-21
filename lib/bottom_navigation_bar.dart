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
    return BottomAppBar(
      color: Colors.deepPurpleAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.star,
              color: selectedIndex == 0 ? Colors.yellow : Colors.white,
            ),
            onPressed: () => handleButtonPress(0),
          ),
          IconButton(
            icon: Icon(
              Icons.home,
              color: selectedIndex == 1 ? Colors.yellow : Colors.white,
            ),
            onPressed: () => handleButtonPress(1),
          ),
          IconButton(
            icon: Icon(
              Icons.flag,
              color: selectedIndex == 2 ? Colors.yellow : Colors.white,
            ),
            onPressed: () => handleButtonPress(2),
          ),
        ],
      ),
    );
  }
}

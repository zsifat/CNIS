
import 'package:chapainawabganjcity/views/about_screen.dart';
import 'package:chapainawabganjcity/views/advertisement_screen.dart';
import 'package:chapainawabganjcity/views/home_screen.dart';
import 'package:chapainawabganjcity/views/notice_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // To keep track of selected index
  int _selectedIndex = 0;

  // Function to update the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List of screens for the BottomNavigationBar items
  static final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const NoticeScreen(),
    const AdvertisementScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Show the selected index
        selectedItemColor: Colors.blue.shade800, // Color for selected item
        onTap: _onItemTapped, // Update selected index on tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'হোম',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'নোটিশ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper), // Megaphone Icon
            label: 'বিজ্ঞাপন',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'প্রোফাইল',
          ),
        ],
      ),
    );
  }
}

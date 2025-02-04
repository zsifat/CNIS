import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../about_screen.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  const DrawerItem({
    super.key,
    required this.title,
    required this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AboutScreen()),
        );
      },
      child: ListTile(
        leading: Icon(iconData, color: Colors.blue.shade800),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
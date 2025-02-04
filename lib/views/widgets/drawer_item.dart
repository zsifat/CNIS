import 'package:flutter/material.dart';

Widget drawerItem(IconData icon, String title) {
  return ListTile(
    leading: Icon(icon, color: Colors.blue.shade800),
    title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    onTap: () {},
  );
}
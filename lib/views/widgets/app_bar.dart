
import 'package:flutter/material.dart';

AppBar buildAppBar(String title, {bool? centerTitle = true}) {
  return AppBar(
    centerTitle: centerTitle,
    title: Text(title),
    backgroundColor: const Color(0xFF2E7D32),
  );
}
import 'package:flutter/material.dart';

class MyListTileDrawer extends StatelessWidget {
  final IconData? icon;
  final String text;
  void Function()? onTap;

  MyListTileDrawer(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_wall_app/src/components/list_tile_drawer.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onLogoutTap;
  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 65,
                ),
              ),
              MyListTileDrawer(
                  onTap: () => Navigator.pop(context),
                  icon: Icons.home,
                  text: "H O M E"),
              MyListTileDrawer(
                  onTap: onProfileTap,
                  icon: Icons.person,
                  text: "P R O F I L E"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MyListTileDrawer(
                onTap: onLogoutTap, icon: Icons.home, text: "L O G O U T"),
          ),
        ],
      ),
    );
  }
}

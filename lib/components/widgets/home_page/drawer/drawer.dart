import 'package:flutter/material.dart';
import 'package:flutter_chat_messenger_app/components/widgets/home_page/drawer/drawer_list_tile.dart';
import 'package:flutter_chat_messenger_app/config/app_colors.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.onProfile,
    required this.onMessages,
    required this.onLogout,
  });

  final GestureTapCallback onProfile;
  final GestureTapCallback onMessages;
  final GestureTapCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),

              // home list tile
              DrawerListTile(
                icon: Icons.home,
                title: 'H O M E',
                onTap: () => Navigator.of(context).pop(),
              ),

              // profile list tile
              DrawerListTile(
                icon: Icons.person,
                title: 'P R O F I L E',
                onTap: onProfile,
              ), // messages list tile
              DrawerListTile(
                icon: Icons.message_outlined,
                title: 'M E S S A G E S',
                onTap: onMessages,
              ),
            ],
          ),

          // logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: DrawerListTile(
              icon: Icons.logout,
              title: 'L O G O U T',
              onTap: onLogout,
            ),
          ),
        ],
      ),
    );
  }
}

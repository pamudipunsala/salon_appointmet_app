import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/edit_status.dart';
import 'package:salon_appointment_app/login.dart';
import 'package:salon_appointment_app/profile.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertinoDrawer(context)
        : _buildMaterialDrawer(context);
  }

  // Cupertino drawer for iOS
  Widget _buildCupertinoDrawer(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Menu'),
        backgroundColor: const Color.fromARGB(255, 7, 111, 57),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(),
            _buildCupertinoListTile(
              context,
              CupertinoIcons.home,
              'Dashboard',
              onTap: () => Navigator.of(context).pop(),
            ),
            _buildCupertinoListTile(
              context,
              CupertinoIcons.chart_bar,
              'Reports',
              onTap: () {}, // Add navigation logic
            ),
            _buildCupertinoListTile(
              context,
              CupertinoIcons.person,
              'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const ProfileScreenPage()),
                );
              },
            ),
            _buildCupertinoListTile(
              context,
              CupertinoIcons.square_arrow_right,
              'Logout',
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Material drawer for Android
  Widget _buildMaterialDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Reports'),
            onTap: () {}, // Add navigation logic
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileScreenPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Drawer header used for both iOS and Android
  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 7, 111, 57),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: const CircleAvatar(
              radius: 60,
              backgroundImage:
                  AssetImage(''), // Replace with your profile image
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Cupertino list tile for iOS
  Widget _buildCupertinoListTile(
      BuildContext context, IconData icon, String title,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 20),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitness_app/components/drawer_tile.dart';
import 'package:fitness_app/pages/about_page.dart';
import 'package:fitness_app/pages/goals_page.dart';
import 'package:fitness_app/pages/home_page.dart';
import 'package:fitness_app/pages/login_page.dart';
import 'package:fitness_app/pages/profile_page.dart';
import 'package:fitness_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // header
                DrawerHeader(
                  child: Icon(Icons.fitness_center),
                ),
        
                // home tile
                DrawerTile(
                  title: 'H O M E',
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage()
                      ),
                    );
                  } 
                ),

                // profile tile
                DrawerTile(
                  title: 'P R O F I L E',
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  } 
                ),

                // goals tile
                DrawerTile(
                  title: 'G O A L S',
                  leading: const Icon(Icons.sports_score),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoalsPage(),
                      ),
                    );
                  } 
                ),
        
                // settings tile
                DrawerTile(
                  title: 'S E T T I N G S',
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage()
                      ),
                    );
                  },
                ),

                // about tile
                DrawerTile(
                  title: 'A B O U T',
                  leading: const Icon(Icons.info),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutPage()
                      ),
                    );
                  } 
                ),
              ],
            ),

            // logout tile
            DrawerTile(
              title: 'L O G O U T',
              leading: const Icon(Icons.logout),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage()
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
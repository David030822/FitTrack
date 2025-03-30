// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:fitness_app/components/drawer_tile.dart';
import 'package:fitness_app/pages/about_page.dart';
import 'package:fitness_app/pages/goals_page.dart';
import 'package:fitness_app/pages/home_page.dart';
import 'package:fitness_app/pages/login_page.dart';
import 'package:fitness_app/pages/profile_page.dart';
import 'package:fitness_app/pages/settings_page.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the stored token
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

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
                  onTap: () async {
                    Navigator.pop(context);

                    final token = await AuthService.getToken();
                    if (token == null) {
                      showError("Error: No token found");
                      debugPrint("Token is NULL!");
                      return;
                    } else {
                      debugPrint("Token retrieved successfully: $token");
                    }

                    if (token != null) {
                      final parts = token.split('.');
                      if (parts.length == 3) {
                        final payload = jsonDecode(
                          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
                        );

                        debugPrint("Decoded Payload: $payload");
                      } else {
                        debugPrint("Invalid Token Format!");
                      }
                    }

                    final userId = await AuthService.getUserIdFromToken(token);
                    if (userId == null) {
                      showError("Error: Could not extract userId from token");
                      debugPrint("Failed to extract userId from token!");
                      return;
                    } else {
                      debugPrint("Extracted userId: $userId");
                    }

                    // Fetch user data
                    final user = await ApiService.getUserData(userId, token);
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                      );
                    } else {
                      showError("Error loading user data");
                    }
                  },
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
                logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<int?> getUserIdFromToken(String token) async {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      return payload['userId']; // Ensure backend includes `userId` in JWT payload
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  // Google Sign In
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      // 1. Start the sign-in flow
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return null; // User canceled login

      // 2. Retrieve authentication tokens
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // 3. Create credentials
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // 4. Sign in with Firebase
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // 5. Debug: Print user data
      print("✅ Google Sign-In Success: ${userCredential.user?.email}");

      // 6. Navigate after login
      Navigator.pushReplacementNamed(context, '/home');

      return userCredential;
    } catch (e, stacktrace) {
      print("❌ Error signing in with Google: $e\n$stacktrace");
      return null;
    }
  }
}
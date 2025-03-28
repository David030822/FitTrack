// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/my_button.dart';
import 'package:fitness_app/components/my_text_field.dart';
import 'package:fitness_app/components/square_tile.dart';
import 'package:fitness_app/pages/facebook_page.dart';
import 'package:fitness_app/pages/forgot_password_page.dart';
import 'package:fitness_app/pages/google_page.dart';
import 'package:fitness_app/pages/home_page.dart';
import 'package:fitness_app/pages/register_page.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text
    );
  }

  void checkLoginStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

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

  Future<void> loginUser(String email, String password) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    final url = Uri.parse("$BASE_URL/api/users/login");  // 1
    // final url = Uri.parse("$BASE_URL/api/users/login");   // 2

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      print("✅Login successful!");

      final responseData = jsonDecode(response.body);
      String token = responseData["token"]; // Assuming the backend returns a token

      // Store token (for future authenticated requests)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", token);

      showSuccess("Login successful!");

      // Navigate to HomePage
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      });
    } else {
      print("❌Login failed: ${response.body}");
      showError("Login failed! ${response.body}");
    }

    // pop loading circle
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true, // Automatically adjust when the keyboard appears
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),

                      // logo
                      Icon(
                        Icons.lock,
                        size: 100,
                      ),

                      SizedBox(height: 50),

                      // welcome message
                      Text(
                        'Welcome back, you\'ve been missed',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 25),

                      // email textfield
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),

                      SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),

                      SizedBox(height: 10),

                      // forgot password?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      // sign in button
                      MyButton(
                        text: 'Sign In',
                        onTap: () {
                          loginUser(emailController.text, passwordController.text);
                        },
                      ),

                      SizedBox(height: 50),

                      // or continue with
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 50),

                      // google + facebook sign in buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // google button
                          GestureDetector(
                            // onTap: () => AuthService().signInWithGoogle(context),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GooglePage(),
                                ),
                              );
                            },
                            child: SquareTile(
                              height: 40,
                              imagePath: 'assets/images/google.png',
                            ),
                          ),

                          SizedBox(width: 10),

                          // facebook button
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FacebookPage(),
                                ),
                              );
                            },
                            child: SquareTile(
                              height: 40,
                              imagePath: 'assets/images/facebook.png',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      // not a member? Register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Register now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
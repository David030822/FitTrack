// ignore_for_file: prefer_const_constructors

import 'package:fitness_app/components/my_button.dart';
import 'package:fitness_app/components/my_text_field.dart';
import 'package:fitness_app/pages/login_page.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void showError(String message) {
    print("❌ showError() called: $message");
    ScaffoldMessenger.of(Navigator.of(context).overlay!.context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void showSuccess(String message) {
    print("✅ showSuccess() called: $message");
    ScaffoldMessenger.of(Navigator.of(context).overlay!.context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> registerUser() async {
    const String apiUrl = "$BASE_URL/api/users/register";  // PC1 IP
    // const String apiUrl = "$BASE_URL/api/users/register";   // PC2 IP

    if (passwordController.text != confirmPasswordController.text) {
      showError("Passwords do not match!");
      return;
    }

    Map<String, dynamic> userData = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "email": emailController.text,
      "phoneNum": phoneController.text,
      "username": usernameController.text,
      "password": passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      print("📢 Response Status Code: ${response.statusCode}");
      print("📢 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ SUCCESS: User registered!");

        if (jsonDecode(response.body)["message"] == "Registration successful") {
          showSuccess("User registered successfully!");  // ✅ Show GREEN SnackBar
        }

        // if (mounted) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => HomePage()),
        //   );
        // }
        // After successful registration:
        final token = await AuthService.getToken();
        final userId = await AuthService.getUserIdFromToken(token!);
        final user = await ApiService.getUserData(userId!, token);

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          showError("Failed to load user data after registration");
        }
      } else {
        try {
          var responseBody = jsonDecode(response.body);
          print("❌ ERROR: ${responseBody["message"]}");
          showError(responseBody["message"] ?? "Registration failed");
        } catch (e) {
          print("❌ ERROR decoding response: $e");
          showError("Unexpected response from server.");
        }
      }
    } catch (error) {
      print("❌ NETWORK ERROR: $error");
      showError("Something went wrong: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true,  // This helps in automatically resizing the body to avoid the keyboard
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
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
                      SizedBox(height: 30),
                      
                      // logo
                      Icon(
                        Icons.app_registration,
                        size: 100,
                      ),
                      
                      SizedBox(height: 50),
                      
                      // welcome message
                      Text(
                        'Let\'s create an account for you!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                        ),
                      ),
                      
                      SizedBox(height: 25),

                      const Text('* Required'),
                      const SizedBox(height: 10),
                      
                      // first name
                      MyTextField(
                        controller: firstNameController,
                        hintText: '*First Name',
                        obscureText: false,
                      ),
                      
                      SizedBox(height: 10),
                      
                      // last name
                      MyTextField(
                        controller: lastNameController,
                        hintText: '*Last Name',
                        obscureText: false,
                      ),
                      
                      SizedBox(height: 10),
                      
                      // email
                      MyTextField(
                        controller: emailController,
                        hintText: '*Email',
                        obscureText: false,
                      ),
                      
                      SizedBox(height: 10),

                      // phone
                      MyTextField(
                        controller: phoneController,
                        hintText: 'Phone number',
                        obscureText: false,
                      ),
                      
                      SizedBox(height: 10),
                      
                      // username textfield
                      MyTextField(
                        controller: usernameController,
                        hintText: '*Username',
                        obscureText: false,
                      ),
                      
                      SizedBox(height: 10),
                      
                      // password textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: '*Password',
                        obscureText: true,
                      ),
                      
                      SizedBox(height: 10),
                      
                      // confirm password
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: '*Confirm Password',
                        obscureText: true,
                      ),
                      
                      SizedBox(height: 25),
                      
                      // register now button
                      MyButton(
                        text: 'Register Now',
                        onTap: () {
                          registerUser();
                        },
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
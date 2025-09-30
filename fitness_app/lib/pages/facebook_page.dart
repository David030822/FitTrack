// ignore_for_file: prefer_const_constructors

import 'package:fitness_app/components/my_button.dart';
import 'package:fitness_app/components/my_text_field.dart';
import 'package:fitness_app/components/square_tile.dart';
import 'package:fitness_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class FacebookPage extends StatelessWidget {
  FacebookPage({super.key});

  // text editing controller
  final emailController = TextEditingController();

  // for textfield focus
  // FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
          
              // facebook logo
              SquareTile(
                imagePath: 'assets/images/facebook.png',
                height: 100
              ),
          
              SizedBox(height: 50),
              
              // email
              MyTextField(
                controller: emailController,
                hintText: 'Enter your email',
                obscureText: false
              ),

              SizedBox(height: 50),

              // confirm button
              MyButton(
                text: 'Confirm',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      )
    );
  }
}
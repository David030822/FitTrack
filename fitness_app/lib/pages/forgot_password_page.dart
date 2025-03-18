import 'package:fitness_app/components/my_button.dart';
import 'package:fitness_app/components/my_text_field.dart';
import 'package:fitness_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

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
              const SizedBox(height: 50),
          
              // key logo
              const Icon(
                Icons.key,
                size: 100,
              ),
          
              const SizedBox(height: 50),
              
              // email
              MyTextField(
                // focusNode: myFocusNode,
                controller: emailController,
                hintText: 'Enter your email',
                obscureText: false
              ),

              const SizedBox(height: 50),

              // confirm button
              MyButton(
                text: 'Confirm',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
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

import 'package:fitness_app/network/apiclient.dart';
import 'package:fitness_app/network/responses/api_base_response.dart';
import 'package:fitness_app/network/responses/splash_response.dart';
import 'package:flutter/material.dart';

class UserData extends ChangeNotifier{
  UserData({required this.apiClient});
  /// I use static because I need to access these two fields in nearly every API call
  static late String udid;
  static String userId = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  
  final ApiClient apiClient;
  late bool reLogin = false;

  static bool isLoggedIn() => userId != "";

  static void initalizeUdid(String value) {
    udid = value;
  }

  Future<bool> init() async {
      try {
        final response = await apiClient.callSplash();
        if (response.success != "0") {
          reLogin = true;
          userId = response.userData["UserID"];
          email = response.userData["email"];
          firstName = response.userData["firstName"];
          lastName = response.userData["lastName"];
          
          return true;
        }
      } catch (e) {
        return false;
    }
    return false;
  }

  Future<bool> login(String email, String password, BuildContext context) async {
    try {
      late ApiBaseResponse response;
        response = await apiClient.callLogin(
            email: email,
            password: password,);
        // if it logged in
        if(response.success != "0") {
          // we save the data
          response = response as SplashResponse;
          this.email = email;
          userId = response.userData["UserID"];
          firstName = response.userData["firstName"];
          lastName = response.userData["lastName"];
        } else {
          false;
        }
        return true;
    } catch (exception) {
      showCustomAlertDialog(context, "Login failed. Please check your credentials and try again.", 'Login failed');
      return false;
    }
  }
}
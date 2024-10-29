// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/api/firebase_api.dart';
import 'package:fitness_app/database/food_database.dart';
import 'package:fitness_app/database/goal_database.dart';
import 'package:fitness_app/firebase_options.dart';
import 'package:fitness_app/network/apiclient.dart';
import 'package:fitness_app/pages/login_page.dart';
import 'package:fitness_app/pages/notification_page.dart';
import 'package:fitness_app/pages/training_page.dart';
import 'package:fitness_app/providers/user_data.dart';
import 'package:fitness_app/responsive/desktop_scaffold.dart';
// ignore: unused_import
import 'package:fitness_app/responsive/mobile_scaffold.dart';
import 'package:fitness_app/responsive/responsive_layout.dart';
import 'package:fitness_app/responsive/tablet_scaffold.dart';
import 'package:fitness_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

final navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  UserData userData = UserData(apiClient: ApiClient(client: http.Client()));

  // initialize databases
  await GoalDatabase.initialize();
  await GoalDatabase().saveFirstLaunchDate();
  await FoodDatabase.initialize();

  FlutterNativeSplash.removeAfter(initialization);

  runApp(
    MultiProvider(
      providers: [
        // Food provider
        ChangeNotifierProvider(create: (context) => FoodDatabase()),

        ChangeNotifierProvider(create: (context) => userData),


        // Goal provider
        ChangeNotifierProvider(create: (context) => GoalDatabase()),
        
        // Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: ResponsiveLayout(
        mobileScaffold: /*const MobileScaffold(),*/ const LoginPage(),
        tabletScaffold: const TabletScaffold(),
        desktopScaffold: const DesktopScaffold(),
      ),
      navigatorKey: navigatorKey,
      routes: {
        '/training_page': (context) => const TrainingPage(),
        '/noti_screen': (context) => const NotificationPage(),
      },
    );
  }
}
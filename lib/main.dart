import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tasker/services/auth_services.dart';

import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasker',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: "Raleway",
      ),
      home: AuthService().firebaseAuth.currentUser == null
          ? SignupScreen()
          : HomeScreen(AuthService().firebaseAuth.currentUser!),
    );
  }
}

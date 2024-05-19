import 'dart:io';
import 'package:cms/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cms/features/app/splash_screen.dart';
import 'package:cms/features/user_auth/presentation/pages/home_page.dart';
import 'package:cms/features/user_auth/presentation/pages/login_page.dart';
import 'package:cms/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDPsqD7lgJWP048GePK9k9V3sg5eVOrvvs',
              appId: '1:36799325304:android:2f090e5be5b634eea4798d',
              messagingSenderId: '36799325304',
              projectId: 'cms-app-1b11b'))
      : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CONTRASAVE',
      routes: {
        '/': (context) => SplashScreen(
              child: LoginPage(), 
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/dashboard': (context) => Dashboard(),
      },
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_registration_app/Screens/homepage.dart';
import 'package:firebase_registration_app/Screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Register App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const RegisterApp());
  }
}

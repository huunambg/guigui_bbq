import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/firebase_options.dart';
import 'package:qlnh/screen/navbar/navbar.dart';
import 'dependecy_injection.dart' as dependecy_injection;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dependecy_injection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(debugShowCheckedModeBanner: false,
      title: 'Gui Gui BBQ',
      home: Navbar(),
    );
  }
}

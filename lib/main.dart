import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/firebase_options.dart';
import 'package:qlnh/screen/together/splash/splash.dart';
import 'dependecy_injection.dart' as dependecy_injection;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dependecy_injection.init();
  runApp(const MyApp());
}

// hihi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Gui Gui BBQ',
      home: SplashScreen(),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('vi', 'VN'), // Add Vietnamese
      ],
      locale: Locale('vi', 'VN'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/screen/splash/controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashCtl = Get.find<SplashController>();
  @override
  void initState() {
    super.initState();
    splashCtl.handleNavigate();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Spacer(),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 160.0,
                height: 160.0,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              "Gui Gui BBQ",
              style: GlobalTextStyles.font24w700ColorBlack,
            ),
            const SizedBox(height: 20),
            const Spacer(),
            SizedBox(
              width: w * 0.66,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(63.0),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey.withOpacity(0.4),
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 14.0,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "Vui lòng chờ",
                    style: GlobalTextStyles.font12w400ColorBlack,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

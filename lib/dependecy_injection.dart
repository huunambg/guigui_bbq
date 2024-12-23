
import 'package:qlnh/screen/splash/controller/splash_controller.dart';
import '/util/preferences_util.dart';
import 'package:get/get.dart';
import 'screen/login/controller/login_controller.dart';

Future<void> init() async {
  await PreferencesUtil.init();

  final loginController = LoginController();
  Get.lazyPut(() => loginController, fenix: true);
  final splashController = SplashController();
  Get.lazyPut(() => splashController, fenix: true);

}

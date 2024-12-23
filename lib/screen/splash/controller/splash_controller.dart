import 'package:get/get.dart';
import '/config/api_state.dart';
import '/model/acount.dart';
import '/model/user.dart';
import '/screen/login/controller/login_controller.dart';
import '/screen/login/login_screen.dart';
import '/screen/navbar/navbar.dart';
import '/screen/oboarding/onboarding.dart';
import '/services/api.dart';
import '/util/preferences_util.dart';

class SplashController extends GetxController {
  var apiState = ApiState.success.obs;

  void handleNavigate() async {
    String? email = PreferencesUtil.getEmail();
    String? password = PreferencesUtil.getPassword();
    PreferencesUtil.getFirstTime();
    await Future.delayed(
      2.seconds,
    );
    PreferencesUtil.setFirstTime(false);
    if (PreferencesUtil.getFirstTime()) {
      Future.delayed(
        1.seconds,
        () => Get.offAll(() => const OnboardingScreen()),
      );
    } else {
      if (email != null && password != null) {
        apiState.value = ApiState.loading;
        try {
          await Future.delayed(1.seconds);
          final result = await ApiService()
              .login(Account(email: email, password: password));
          Get.find<LoginController>().userData.value =
              User.fromJson(result['data']);
          Get.find<LoginController>().accessToken = result['token'];
          apiState.value = ApiState.success;
          Get.offAll(() => const Navbar());
        } catch (e) {
          apiState.value = ApiState.success;
          Get.offAll(() => const LoginScreen());
        }
      } else {
        Get.offAll(() => const LoginScreen());
      }
    }
  }
}

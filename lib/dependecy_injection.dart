
import 'package:qlnh/screen/together/splash/controller/splash_controller.dart';
import 'package:qlnh/screen/together/user/transaction/controller/transaction_controller.dart';
import 'package:qlnh/screen/together/user/update_transaction/controller/update_transaction_controller.dart';
import 'package:qlnh/user/login/controller/login_controller.dart';
import '/util/preferences_util.dart';
import 'package:get/get.dart';
import 'screen/together/user/add_transaction/controller/add_transaction_controller.dart';
import 'screen/together/user/menu/controller/menu_controller.dart';

Future<void> init() async {
  await PreferencesUtil.init();

  final loginController = LoginController();
  Get.lazyPut(() => loginController, fenix: true);
  final splashController = SplashController();
  Get.lazyPut(() => splashController, fenix: true);
  final addTransactionController = AddTransactionController();
  Get.lazyPut(() => addTransactionController, fenix: true);
  final updateTransactionController = UpdateTransactionController();
  Get.lazyPut(() => updateTransactionController, fenix: true);
  final menuController = MenusController();
  Get.lazyPut(() => menuController, fenix: true);
  final transactionController = TransactionController();
  Get.lazyPut(() => transactionController, fenix: true);
}

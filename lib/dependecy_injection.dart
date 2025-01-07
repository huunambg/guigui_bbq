import 'package:qlnh/screen/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/screen/menu/controller/menu_controller.dart';
import 'package:qlnh/screen/splash/controller/splash_controller.dart';
import 'package:qlnh/screen/transaction/controller/transaction_controller.dart';
import 'package:qlnh/screen/update_transaction/controller/update_transaction_controller.dart';
import '/util/preferences_util.dart';
import 'package:get/get.dart';
import 'screen/login/controller/login_controller.dart';

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

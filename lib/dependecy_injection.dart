import 'package:qlnh/screen/admin/buffer_admin/controller/buffer_controller.dart';
import 'package:qlnh/screen/admin/personnel/controller/personnel_controller.dart';
import 'package:qlnh/screen/together/splash/controller/splash_controller.dart';
import 'package:qlnh/screen/user/login/controller/login_controller.dart';
import 'package:qlnh/screen/user/table/controller/table_controller.dart';
import 'package:qlnh/screen/user/transaction/controller/transaction_controller.dart';
import 'package:qlnh/screen/user/update_transaction/controller/update_transaction_controller.dart';
import '/util/preferences_util.dart';
import 'package:get/get.dart';
import 'screen/user/add_transaction/controller/add_transaction_controller.dart';
import 'controller/menu_controller.dart';

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
  final tableController = TableController();
  Get.lazyPut(() => tableController, fenix: true);
  final bufferController = BufferController();
  Get.lazyPut(() => bufferController, fenix: true);
  final userController = UserController();
  Get.lazyPut(() => userController, fenix: true);
}

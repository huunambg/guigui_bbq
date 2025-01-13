import 'package:get/get.dart';
import 'package:qlnh/config/api_state.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/services/api.dart';

class MenusController extends GetxController {
  RxList<Menu> listMenu = <Menu>[].obs;
  Rx<ApiState> apiState = ApiState.loading.obs;

  void getListMenu() async {
    if (apiState.value != ApiState.success) {
      apiState.value = ApiState.loading;
      try {
        listMenu.value = await ApiService().getAllMenu();
        apiState.value = ApiState.success;
      } catch (e) {
        apiState.value = ApiState.failure;
      }
    }
  }
}

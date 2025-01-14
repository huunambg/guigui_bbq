import 'package:get/get.dart';
import 'package:qlnh/config/api_state.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/services/api.dart';

class MenusController extends GetxController {
  RxList<Menu> listMenu = <Menu>[].obs;
  Rx<ApiState> apiState = ApiState.loading.obs;

  void getListMenu() async {
    apiState.value = ApiState.loading;
    try {
      listMenu.value = await ApiService().getAllMenu();
      apiState.value = ApiState.success;
    } catch (e) {
      apiState.value = ApiState.failure;
    }
  }

  void deleteMenu(int id) async {
    try {
      await ApiService().deleteMenu(id);
      int index = listMenu.indexWhere(
        (element) => element.menuId == id,
      );
      listMenu.removeAt(index);
    } catch (e) {}
  }
}

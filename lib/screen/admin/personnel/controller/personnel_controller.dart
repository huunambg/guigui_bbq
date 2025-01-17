import 'package:get/get.dart';
import 'package:qlnh/model/user.dart';
import 'package:qlnh/services/api.dart';

class UserController extends GetxController {
  RxList<User> listUser = <User>[].obs;

  void loadData() async {
    listUser.value = await ApiService().getAllUser();
  }


  Future<void> deleteUser(int id) async {
    await ApiService().deleteUser(id);

    int index = listUser.indexWhere(
      (element) => element.userId == id,
    );

    if (index != -1) {
      listUser.removeAt(index);
    }
  }

  Future<void> updateUser(User user) async {
    await ApiService().updateUser(user);
    int index = listUser.indexWhere(
      (element) => element.userId == user.userId,
    );
    listUser[index] = user;
  }
}

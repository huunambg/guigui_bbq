import 'package:get/get.dart';
import 'package:qlnh/config/api_state.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/services/api.dart';

class TransactionController extends GetxController {
  RxList<Transaction> listTransaction = <Transaction>[].obs;
  Rx<ApiState> apiState = ApiState.loading.obs;

  void getListTransaction() async {
    apiState.value = ApiState.loading;
    listTransaction.value = await ApiService().getAllTransaction();
    apiState.value = ApiState.success;
  }

}

import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  void getListTransactionByDate(DateTime dateTime) async {
    String formattedDate = DateFormat('yyyy-MM-d').format(dateTime);
    apiState.value = ApiState.loading;
    listTransaction.value =
        await ApiService().getAllTransactionByDate(formattedDate);
    apiState.value = ApiState.success;
  }

  Future<void> deleteTransaction(int id) async {
    await ApiService().deleteTransaction(id);

    int index = listTransaction.indexWhere(
      (element) => element.transactionId == id,
    );

    if (index != -1) {
      listTransaction.removeAt(index);
    }
  }
}

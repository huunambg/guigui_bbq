import 'package:get/get.dart';
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/services/api.dart';

class AddTransactionController extends GetxController {
  Rx<Transaction> transactionNew = Transaction().obs;
  RxList<Buffer> listBuffer = <Buffer>[].obs;

  void getListBuffer() async {
    listBuffer.value = await ApiService().getAllBuffer();
  }

  void updateTransaction(Transaction transaction) {
    transactionNew.value = transaction;
  }

  void clearTransaction() {
    transactionNew.value = Transaction();
  }
}

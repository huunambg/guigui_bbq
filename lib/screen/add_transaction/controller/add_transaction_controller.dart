import 'package:get/get.dart';
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/services/api.dart';

class AddTransactionController extends GetxController {
  Rx<Transaction> transactionNew = Transaction().obs;
  RxList<Buffer> listBuffer = <Buffer>[].obs;
  RxList<OrderDetail> listOrderDetail = <OrderDetail>[].obs;
  void getListBuffer() async {
    listBuffer.value = await ApiService().getAllBuffer();
  }

  void updateTransaction(Transaction transaction) {
    transactionNew.value = transaction;
  }

  void updateQuantity(Transaction transaction) {}


  void addOrderDetail(OrderDetail orderDetail) {
    int index = listOrderDetail.indexWhere(
      (element) => element.menuItemId == orderDetail.menuItemId,
    );

    if (index != -1) {
      listOrderDetail[index] = listOrderDetail[index].copyWith(
          quantity: listOrderDetail[index].quantity! + orderDetail.quantity!);
    } else {}
  }

  void clearTransaction() {
    transactionNew.value = Transaction();
  }
}

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/screen/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/services/api.dart';

class UpdateTransactionController extends GetxController {
  RxList<OrderDetail> listOrderDetail = <OrderDetail>[].obs;
  RxBool isShowQR = false.obs;
  RxString selectNumberPeople = "0".obs;
  Rx<Buffer> selectBuffer = Buffer().obs;
  RxInt totalMoney = 0.obs;
  Rx<Transaction> transaction = Transaction().obs;
  RxInt totalOldMenu = 0.obs;
  RxInt selectPayment = 0.obs;
  RxBool isFinish = false.obs;
  Future<void> initUpdate(int tableId) async {
    transaction.value = await ApiService().getLastTransactionByTable(tableId);

    for (var buffer in Get.find<AddTransactionController>().listBuffer) {
      if (buffer.bufferId == transaction.value.bufferId) {
        selectBuffer.value = buffer;
        break;
      }
    }
    listOrderDetail.value =
        await ApiService().getOrderDetailByOrder(transaction.value.orderId!);
    totalOldMenu.value = listOrderDetail.length;
    selectNumberPeople.value = transaction.value.countPeople.toString();
    updateTotalMoney();
  }

  void clearData() {
    listOrderDetail.clear();
    selectNumberPeople.value = "0";
    selectBuffer.value = Buffer();
    totalMoney.value = 0;
    isShowQR.value = false;
    isFinish.value = false;
  }

  void updateSelectNumberPeople(String value) {
    selectNumberPeople.value = value;
    updateTotalMoney();
  }

  void updateSelectBuffer(Buffer buffer) {
    selectBuffer.value = buffer;
    updateTotalMoney();
  }

  void updateTotalMoney() {
    if (selectNumberPeople.value == "0" ||
        selectBuffer.value.bufferId == null) {
      totalMoney.value = 0;
      return;
    }
    int temp = 0;

    for (var element in listOrderDetail) {
      temp += element.totalPrice!;
    }
    totalMoney.value = temp +
        (int.parse(selectNumberPeople.value) *
            selectBuffer.value.pricePerPerson!);
  }

  void updateQuantity(Transaction transaction) {}

  void addOrderDetail(OrderDetail orderDetail) {
    int index = listOrderDetail.indexWhere(
      (element) => element.menuItemId == orderDetail.menuItemId,
    );
    if (index != -1) {
      listOrderDetail[index] = listOrderDetail[index].copyWith(
          quantity: listOrderDetail[index].quantity! + orderDetail.quantity!,
          totalPrice:
              (listOrderDetail[index].quantity! + orderDetail.quantity!) *
                  orderDetail.price!);
      listOrderDetail.refresh();
    } else {
      listOrderDetail.add(orderDetail);
    }
    updateTotalMoney();
  }

  void updateTransaction(
      Transaction transaction, BuildContext context, String idTableFB) async {
    try {
      for (var orderDetail in listOrderDetail) {
        await ApiService().updateOrderDetail(orderDetail);
        print(orderDetail.toJsonUpdate());
      }
      for (int i = 0; i < listOrderDetail.length; i++) {
        if (i >= totalOldMenu.value) {
          await ApiService().addOrderDetail(
              listOrderDetail[i].copyWith(orderId: transaction.orderId));
        } else {
          await ApiService().updateOrderDetail(listOrderDetail[i]);
        }
      }
      await ApiService().updateTransaction(transaction.copyWith(
          transactionId: this.transaction.value.transactionId,
          bufferId: selectBuffer.value.bufferId,
          countPeople: int.parse(selectNumberPeople.value)));
      if (isFinish.value) {
        fs.FirebaseFirestore.instance
            .collection("Table")
            .doc(idTableFB)
            .update({
          "status": "Available",
        });
      }
    } catch (e) {
      CherryToast.error(
        title: const Text("Cập nhật hóa đơn thất bại"),
      ).show(context);
      return;
    }
    Get.back();

    CherryToast.success(
      title: const Text("Cập nhật hóa đơn thành công"),
    ).show(context);
  }


}

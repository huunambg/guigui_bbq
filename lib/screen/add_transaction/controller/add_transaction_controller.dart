import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/orders.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/services/api.dart';

class AddTransactionController extends GetxController {
  RxList<Transaction> transactionNew = <Transaction>[].obs;
  RxList<Buffer> listBuffer = <Buffer>[].obs;
  RxList<OrderDetail> listOrderDetail = <OrderDetail>[].obs;
  RxBool isShowQR = false.obs;
  RxString selectNumberPeople = "0".obs;
  Rx<Buffer> selectBuffer = Buffer().obs;
  RxInt totalMoney = 0.obs;

  void clearData() {
    listOrderDetail.clear();
    selectNumberPeople.value = "0";
    selectBuffer.value = Buffer();
    totalMoney.value = 0;
    isShowQR.value = false;
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

  void getListBuffer() async {
    listBuffer.value = await ApiService().getAllBuffer();
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

  void addTransaction(Orders order, Transaction transaction,BuildContext context) async {
    try {
      int idOrder = await ApiService().addOrder(order);
      for (var orderDetail in listOrderDetail) {
        await ApiService()
            .addOrderDetail(orderDetail.copyWith(orderId: idOrder));
      }
      await ApiService().addTransaction(
          transaction.copyWith(orderId: idOrder, amount: totalMoney.value));
    } catch (e) {
      print(e);
    }
    Get.back();

    CherryToast.success(
      title: const Text("Tạo hóa đơn thành công"),
    ).show(context);
  }
}

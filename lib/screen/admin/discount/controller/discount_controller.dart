import 'package:get/get.dart';
import 'package:qlnh/model/discount.dart';

import 'package:qlnh/services/api.dart';

class DiscountController extends GetxController {
  RxList<Discount> listDiscount = <Discount>[].obs;

  void getListDiscount() async {
    listDiscount.value = await ApiService().getAllDiscount();
  }

  Future<void> deleteDiscount(int id) async {
    await ApiService().deleteDiscount(id);

    int index = listDiscount.indexWhere(
      (element) => element.discountId == id,
    );

    if (index != -1) {
      listDiscount.removeAt(index);
    }
  }

  Future<void> updateDiscount(Discount discount) async {
    await ApiService().updateDiscount(discount);
    int index = listDiscount.indexWhere(
      (element) => element.discountId == discount.discountId,
    );
    listDiscount[index] = discount;
  }
}

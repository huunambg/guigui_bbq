import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:qlnh/screen/admin/add_discount/add_table_screen.dart';
import 'package:qlnh/screen/admin/discount/controller/discount_controller.dart';
import 'package:qlnh/screen/admin/discount/widget/item_discount.dart';
import 'package:qlnh/screen/admin/update_discount/update_discount_screen.dart';
import 'package:qlnh/widget/body_background.dart';

class DiscountAdminScreen extends StatefulWidget {
  const DiscountAdminScreen({super.key});

  @override
  State<DiscountAdminScreen> createState() => _DiscountAdminScreenState();
}

class _DiscountAdminScreenState extends State<DiscountAdminScreen> {
  final discountCtl = Get.find<DiscountController>();
  late SwipeActionController controller;

  @override
  void initState() {
    super.initState();
    discountCtl.getListDiscount();
    controller = SwipeActionController(selectedIndexPathsChangeCallback:
        (changedIndexPaths, selected, currentCount) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Buffer",
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(AddDiscountScreen());
              },
              child: const Icon(
                Icons.add,
                size: 28,
              ),
            ),
            const Gap(12.0)
          ],
        ),
        body: Obx(() => ListView.separated(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12.0),
              itemCount: discountCtl.listDiscount.length,
              itemBuilder: (context, index) {
                return _item(context, index);
              },
            )),
      ),
    );
  }

  Widget _item(BuildContext ctx, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: SwipeActionCell(
          controller: controller,
          index: index,
          // Required!
          key: ValueKey(discountCtl.listDiscount[index]),
          selectedForegroundColor: Colors.black.withAlpha(30),
          trailingActions: [
            SwipeAction(
                backgroundRadius: 8.0,
                title: "Xóa",
                closeOnTap: true,
                onTap: (handler) async {
                  PanaraConfirmDialog.show(
                    context,
                    title: "Xóa Buffer",
                    message: "Bạn có muốn xóa Buffer ra khỏi danh sách",
                    confirmButtonText: "Xóa",
                    cancelButtonText: "Quay lại",
                    onTapCancel: () {
                      Get.back();
                    },
                    onTapConfirm: () {
                      discountCtl
                          .deleteDiscount(
                              discountCtl.listDiscount[index].discountId!)
                          .then(
                        (value) {
                          CherryToast.success(
                            title: const Text("Đã xóa Buffer"),
                          ).show(context);
                        },
                      ).catchError((e) {
                        CherryToast.success(
                          title: const Text("Xóa Buffer thất bại"),
                        ).show(context);
                      });
                      Get.back();
                    },
                    panaraDialogType: PanaraDialogType.warning,
                    barrierDismissible: false,
                  );
                }),
            SwipeAction(
                backgroundRadius: 8.0,
                title: "Sửa",
                color: Colors.lightGreen,
                onTap: (handler) {
                  Get.to(() => UpdateDiscountScreen(
                      discount: discountCtl.listDiscount[index]));
                }),
          ],
          child: ItemDiscount(discount: discountCtl.listDiscount[index])),
    );
  }
}

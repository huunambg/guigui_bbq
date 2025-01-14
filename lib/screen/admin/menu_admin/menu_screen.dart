import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:qlnh/config/api_state.dart';
import 'package:qlnh/screen/admin/add_menu/add_menu_screen.dart';
import 'package:qlnh/screen/admin/menu_admin/widget/item_menu.dart';
import 'package:qlnh/controller/menu_controller.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:qlnh/screen/update_menu/update_menu_screen.dart';
import 'package:qlnh/widget/body_background.dart';

class MenuAdminScreen extends StatefulWidget {
  const MenuAdminScreen({super.key});

  @override
  State<MenuAdminScreen> createState() => _MenuAdminScreenState();
}

class _MenuAdminScreenState extends State<MenuAdminScreen> {
  final menuCtl = Get.find<MenusController>();
  late SwipeActionController controller;

  @override
  void initState() {
    super.initState();

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
          title:
              const Text("Menu", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(AddMenuScreen());
              },
              child: const Icon(
                Icons.add,
                size: 28,
              ),
            ),
            const Gap(12.0)
          ],
        ),
        body: Obx(
          () {
            if (menuCtl.apiState.value == ApiState.failure) {
              return const Center(
                  child: Text("Error",
                      style: TextStyle(color: Colors.red, fontSize: 18.0)));
            } else if (menuCtl.apiState.value == ApiState.success) {
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12.0),
                itemCount: menuCtl.listMenu.length,
                itemBuilder: (context, index) {
                  return _item(context, index);
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
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
          key: ValueKey(menuCtl.listMenu[index]),
          selectedForegroundColor: Colors.black.withAlpha(30),
          trailingActions: [
            SwipeAction(
                backgroundRadius: 8.0,
                title: "Xóa",
                closeOnTap: true,
                onTap: (handler) async {
                  PanaraConfirmDialog.show(
                    context,
                    title: "Xóa thực phẩm",
                    message: "Bạn có xóa sản phẩm khỏi danh sách",
                    confirmButtonText: "Xóa",
                    cancelButtonText: "Quay lại",
                    onTapCancel: () {
                      Get.back();
                    },
                    onTapConfirm: () {
                      menuCtl.deleteMenu(menuCtl.listMenu[index].menuId!);
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
                  Get.to(() => UpdateMenuScreen(
                        menuToEdit: menuCtl.listMenu[index],
                      ));
                }),
          ],
          child: ItemMenuCustom(menu: menuCtl.listMenu[index])),
    );
  }
}

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:qlnh/screen/admin/personnel/controller/personnel_controller.dart';
import 'package:qlnh/screen/admin/personnel/item_user.dart';
import 'package:qlnh/screen/admin/update_user_admin/update_user_admin_screen.dart';
import 'package:qlnh/widget/body_background.dart';

class PersonnelAdminScreen extends StatefulWidget {
  const PersonnelAdminScreen({super.key});

  @override
  State<PersonnelAdminScreen> createState() => _PersonnelAdminScreenState();
}

class _PersonnelAdminScreenState extends State<PersonnelAdminScreen> {
  final userCtl = Get.find<UserController>();
  late SwipeActionController controller;

  @override
  void initState() {
    super.initState();
    userCtl.loadData();
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
          title: const Text("Nhân viên",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Obx(() => ListView.separated(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12.0),
              itemCount: userCtl.listUser.length,
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
          key: ValueKey(userCtl.listUser[index]),
          selectedForegroundColor: Colors.black.withAlpha(30),
          trailingActions: [
            SwipeAction(
                backgroundRadius: 8.0,
                title: "Xóa",
                closeOnTap: true,
                onTap: (handler) async {
                  PanaraConfirmDialog.show(
                    context,
                    title: "Xóa nhân viên",
                    message: "Bạn có muốn xóa nhân viên ra khỏi danh sách",
                    confirmButtonText: "Xóa",
                    cancelButtonText: "Quay lại",
                    onTapCancel: () {
                      Get.back();
                    },
                    onTapConfirm: () {
                      userCtl.deleteUser(userCtl.listUser[index].userId!).then(
                        (value) {
                          CherryToast.success(
                            title: const Text("Đã xóa nhân viên"),
                          ).show(context);
                        },
                      ).catchError((e) {
                        CherryToast.success(
                          title: const Text("Xóa nhân viên thất bại"),
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
                  Get.to(() =>
                      UpdateUserAdminScreen(user: userCtl.listUser[index]));
                }),
          ],
          child: ItemUserCustom(user: userCtl.listUser[index])),
    );
  }
}

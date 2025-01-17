import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:qlnh/screen/admin/add_buffer/add_table_screen.dart';
import 'package:qlnh/screen/admin/buffer_admin/controller/buffer_controller.dart';
import 'package:qlnh/screen/admin/buffer_admin/widget/item_buffer.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:qlnh/screen/admin/update_buffer/update_buffer_screen.dart';
import 'package:qlnh/widget/body_background.dart';

class BufferAdminScreen extends StatefulWidget {
  const BufferAdminScreen({super.key});

  @override
  State<BufferAdminScreen> createState() => _BufferAdminScreenState();
}

class _BufferAdminScreenState extends State<BufferAdminScreen> {
  final bufferCtl = Get.find<BufferController>();
  late SwipeActionController controller;

  @override
  void initState() {
    super.initState();
    bufferCtl.loadData();
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
                Get.to(AddBufferScreen());
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
              itemCount: bufferCtl.listBuffer.length,
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
          key: ValueKey(bufferCtl.listBuffer[index]),
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
                      bufferCtl
                          .deleteBuffer(bufferCtl.listBuffer[index].bufferId!)
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
                  Get.to(() =>
                      UpdateBufferScreen(buffer: bufferCtl.listBuffer[index]));
                }),
          ],
          child: ItemBufferCustom(buffer: bufferCtl.listBuffer[index])),
    );
  }
}
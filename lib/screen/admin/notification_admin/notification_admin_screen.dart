import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';

class NotificationAdminScreen extends StatefulWidget {
  const NotificationAdminScreen({super.key});

  @override
  State<NotificationAdminScreen> createState() =>
      _NotificationAdminScreenState();
}

class _NotificationAdminScreenState extends State<NotificationAdminScreen> {
  final CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');

  void showAddNotificationSheet() {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Thêm thông báo mới",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Tiêu đề",
                style: GlobalTextStyles.font14w600ColorBlack,
              ),
              Gap(4.0),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Nhập tiêu đề',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text(
                "Nội dung",
                style: GlobalTextStyles.font14w600ColorBlack,
              ),
              Gap(4.0),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Nhập nội dung',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.message),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Get.back();
                      await FirebaseFirestore.instance
                          .collection('notifications')
                          .add({
                        'title': _titleController.text,
                        'message': _messageController.text,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      CherryToast.success(
                              title: const Text('Thông báo đã được thêm!'))
                          .show(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlobalColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Thêm thông báo',
                    style: GlobalTextStyles.font16w600ColorWhite
                        .copyWith(color: Colors.white.withOpacity(.9)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: showAddNotificationSheet,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            notifications.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Lỗi khi tải dữ liệu'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Không có thông báo'));
          }

          final notificationDocs = snapshot.data!.docs;

          return ListView.separated(
            padding: EdgeInsets.all(16.0),
            itemCount: notificationDocs.length,
            separatorBuilder: (context, index) => Gap(8.0),
            itemBuilder: (context, index) {
              final notification = notificationDocs[index];
              return _item(context, index, notification);
            },
          );
        },
      ),
    );
  }

  String formatTimestampToDate(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Widget _item(BuildContext ctx, int index, var notification) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: SwipeActionCell(
          controller: controller,
          index: index,
          // Required!
          key: ValueKey(notification),
          selectedForegroundColor: Colors.black.withAlpha(30),
          trailingActions: [
            SwipeAction(
                backgroundRadius: 8.0,
                title: "Xóa",
                closeOnTap: true,
                onTap: (handler) async {
                  PanaraConfirmDialog.show(
                    context,
                    title: "Xóa thông báo",
                    message: "Bạn có xóa thông báo ra khỏi danh sách",
                    confirmButtonText: "Xóa",
                    cancelButtonText: "Quay lại",
                    onTapCancel: () {
                      Get.back();
                    },
                    onTapConfirm: () async {
                      Get.back();
                      await notifications.doc(notification.id).delete();
                      CherryToast.success(
                              title: const Text('Thông báo đã được xóa!'))
                          .show(context);
                    },
                    panaraDialogType: PanaraDialogType.warning,
                    barrierDismissible: false,
                  );
                }),
          ],
          child: Card(
            child: ListTile(
              title: Text(notification['title'] ?? 'Không có tiêu đề'),
              subtitle: Text(notification['message'] ?? 'Không có nội dung'),
              trailing: Text(
                notification['timestamp'] != null
                    ? formatTimestampToDate(
                        notification['timestamp'] as Timestamp)
                    : 'Không có thời gian',
                style: const TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
            ),
          )),
    );
  }
}

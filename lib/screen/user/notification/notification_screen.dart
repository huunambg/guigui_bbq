import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');

  int? _lastNotificationCount; // Trạng thái lưu số lượng thông báo trước đó

  void addNotification() async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': 'Thông báo mới',
      'message': 'Đây là một thông báo mới.',
      'timestamp': FieldValue.serverTimestamp(),
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
              onPressed: () {
                addNotification();
              },
              icon: const Icon(Icons.add))
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

          // Kiểm tra số lượng thông báo mới
          if (_lastNotificationCount != null &&
              _lastNotificationCount! < notificationDocs.length) {
            // Hiển thị thông báo Toast
            final newNotification = notificationDocs.first;
            Fluttertoast.showToast(
              msg: "Thông báo mới: ${newNotification['title']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
            );
          }

          // Cập nhật trạng thái số lượng thông báo
          _lastNotificationCount = notificationDocs.length;

          return ListView.builder(
            itemCount: notificationDocs.length,
            itemBuilder: (context, index) {
              final notification = notificationDocs[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(notification['title'] ?? 'Không có tiêu đề'),
                  subtitle:
                      Text(notification['message'] ?? 'Không có nội dung'),
                  trailing: Text(
                    // Kiểm tra và xử lý giá trị timestamp
                    notification['timestamp'] != null
                        ? formatTimestampToDate(
                            notification['timestamp'] as Timestamp)
                        : 'Không có thời gian',
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String formatTimestampToDate(Timestamp timestamp) {
    // Chuyển đổi Timestamp sang DateTime
    final DateTime dateTime = timestamp.toDate();

    // Định dạng DateTime thành chuỗi theo định dạng "dd/MM/yyyy HH:mm"
    final String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

    return formattedDate;
  }
}

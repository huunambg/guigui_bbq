import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/screen/admin/discount/controller/discount_controller.dart';
import 'package:qlnh/screen/admin/personnel/controller/personnel_controller.dart';
import 'package:qlnh/screen/together/account/account.dart';
import 'package:qlnh/screen/user/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/screen/user/notification/notification_screen.dart';
import 'package:qlnh/screen/user/table/controller/table_controller.dart';
import 'package:qlnh/screen/user/table/table_screen.dart';
import 'package:qlnh/controller/menu_controller.dart';
import 'package:qlnh/screen/user/transaction/transaction_screen.dart';

class NavbarUser extends StatefulWidget {
  const NavbarUser({super.key});

  @override
  State<NavbarUser> createState() => _NavbarUserState();
}

class _NavbarUserState extends State<NavbarUser> {
  final menuCtl = Get.find<MenusController>();
  final tableCtl = Get.find<TableController>();
  final addTransactionCtl = Get.find<AddTransactionController>();
  final userCtl = Get.find<UserController>();
    final discountCtl = Get.find<DiscountController>();
  int _currentIndex = 0;
  final List<Widget> tabs = [
    const TableScreen(), // Tab 2: Replace with your content
    const TransactionScreen(), // Tab 3: Replace with your content
    const NotificationScreen(), // Tab 1: Replace with your content
    const AcountScreen()
  ];
  final AudioPlayer audioPlayer = AudioPlayer();
  final CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');

  int? _lastNotificationCount;
  late StreamSubscription<QuerySnapshot> _notificationsSubscription;

  @override
  void dispose() {
    // Huỷ đăng ký khi màn hình bị đóng
    _notificationsSubscription.cancel();
    super.dispose();
  }

  // Hàm lắng nghe thông báo
  void listenToNotifications() {
    _notificationsSubscription = notifications
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      final notificationDocs = snapshot.docs;

      // Kiểm tra số lượng thông báo mới
      if (_lastNotificationCount != null &&
          _lastNotificationCount! < notificationDocs.length) {
        // Hiển thị thông báo Toast
        final newNotification = notificationDocs.first;
        audioPlayer.play(AssetSource("sounds/sound.mp3"));
        CherryToast.info(
          title: Text('Thông báo mới: ${newNotification['title']}'),
          toastDuration: const Duration(seconds: 5),
        ).show(context);
      }

      // Cập nhật số lượng thông báo
      _lastNotificationCount = notificationDocs.length;

      // Bạn có thể xử lý các thông báo khác ở đây nếu cần
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    listenToNotifications();
  }

  void loadData() {
    discountCtl.getListDiscount();
    menuCtl.getListMenu();
    tableCtl.getListTable();
    userCtl.loadData();
    addTransactionCtl.getListBuffer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(
                  0, -2), // Shadow positioned above the navigation bar
            ),
          ],
        ),
        child: BottomNavigationBar(
          unselectedLabelStyle: GlobalTextStyles.font12w600ColorBlack,
          selectedLabelStyle: GlobalTextStyles.font12w600ColorBlack,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: GlobalColors.primaryDark,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.table_restaurant_rounded),
              label: 'Bàn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_sharp),
              label: 'Hóa đơn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Thông báo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }
}

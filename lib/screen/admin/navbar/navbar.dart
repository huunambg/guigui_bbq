import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/screen/admin/menu_admin/menu_screen.dart';
import 'package:qlnh/screen/admin/notification_admin/notification_admin_screen.dart';
import 'package:qlnh/screen/admin/personnel/controller/personnel_controller.dart';
import 'package:qlnh/screen/admin/transaction_admin/transaction_admin_screen.dart';
import 'package:qlnh/screen/together/account/account.dart';
import 'package:qlnh/screen/user/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/controller/menu_controller.dart';
import 'package:qlnh/screen/user/table/controller/table_controller.dart';
import '../table_admin/table_admin_screen.dart';

class NavBarAdmin extends StatefulWidget {
  const NavBarAdmin({super.key});

  @override
  State<NavBarAdmin> createState() => _NavBarAdminState();
}

class _NavBarAdminState extends State<NavBarAdmin> {
  final iconList = <IconData>[
    Icons.table_bar,
    Icons.menu_book_rounded,
    Icons.payments,
    Icons.person_outline,
  ];

  final addTransactionCtl = Get.find<AddTransactionController>();
  final menuCtl = Get.find<MenusController>();
  final tableCtl = Get.find<TableController>();
  final userCtl = Get.find<UserController>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  int _bottomNavIndex = 0;

  final tab = [
    const TableAdminScreen(),
    const MenuAdminScreen(),
    const TransactionAdminScreen(),
    const AcountScreen(),
  ];

  void loadData() {
    menuCtl.getListMenu();
    tableCtl.getListTable();
    userCtl.loadData();
    addTransactionCtl.getListBuffer();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tab[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Get.to(() => const NotificationAdminScreen());
        },
        child: const Icon(
          Icons.notification_add,
          size: 26,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: GlobalColors.primary,
        height: 80.0,
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }

  Widget textFieldAdd(
      TextEditingController controller, String label, TextInputType type) {
    return TextField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          labelText: label),
    );
  }
}

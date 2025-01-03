import 'package:flutter/material.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/screen/home/home_screen.dart';
import 'package:qlnh/screen/table/table_screen.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;
  final List<Widget> tabs = [
    HomeScreen(), // Tab 1: Replace with your content
    TableScreen(), // Tab 2: Replace with your content
    Container(), // Tab 3: Replace with your content
    Container(), // Tab 4: Replace with your content
  ];

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
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_restaurant_rounded),
              label: 'Danh sách bàn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_sharp),
              label: 'Hóa đơn',
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

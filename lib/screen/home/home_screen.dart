import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        shadowColor: Colors.black.withOpacity(0.25),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 32.0,
              height: 32.0,
            ),
            const Gap(4.0),
            Text(
              "Gui Gui ",
              style: GlobalTextStyles.font21w700ColorWhite
                  .copyWith(color: GlobalColors.primary),
            ),
            Text("BBQ", style: GlobalTextStyles.font21w700ColorBlack)
          ],
        ),
        actions: [
          Image.asset(
            "assets/images/avt.png",
            height: 32.0,
            width: 34.0,
          ),
          Gap(16.0),
        ],
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset("assets/icons/ic_drawer.svg"),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Sử dụng context từ Builder
            },
          ),
        ),
      ),
      body: const Column(
        children: [],
      ),
      drawer: const Drawer(
        child: Column(),
      ),
    );
  }
}

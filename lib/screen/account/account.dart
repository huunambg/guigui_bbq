import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AcountScreen extends StatefulWidget {
  const AcountScreen({super.key});

  @override
  State<AcountScreen> createState() => _AcountScreenState();
}

class _AcountScreenState extends State<AcountScreen> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Gap(30.0),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: EdgeInsets.all(24),
                color: Colors.blueGrey.withOpacity(.2),
                child: Image.asset(
                  "assets/images/avatar.png",
                  width: w * 0.24,
                  height: w * 0.24,
                ),
              ),
            ),
          ),
          Gap(16.0),
          ItemAccount_OK(
              icon: Icons.location_on_outlined,
              onpressed: () {},
              titile: "Địa chỉ"),
          ItemAccount_OK(
              icon: CupertinoIcons.bell, onpressed: () {}, titile: "Thông báo"),
          ItemAccount_OK(
              icon: CupertinoIcons.bell, onpressed: () {}, titile: "Thông báo"),
          ItemAccount_OK(
              icon: CupertinoIcons.bell, onpressed: () {}, titile: "Đăng xuất"),
        ],
      ),
    );
  }
}

class ItemAccount_OK extends StatelessWidget {
  const ItemAccount_OK(
      {super.key,
      required this.icon,
      required this.onpressed,
      required this.titile});
  final icon;
  final GestureTapCallback onpressed;
  final String titile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black12,
        child: ListTile(
          onTap: onpressed,
          leading: Icon(icon),
          title: Text(titile),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

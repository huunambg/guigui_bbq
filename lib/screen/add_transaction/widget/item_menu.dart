import 'package:flutter/material.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/menu.dart';

class ItemMenu extends StatelessWidget {
  const ItemMenu({super.key, required this.isShowMenu, required this.menu});
  final Menu menu;
  final bool isShowMenu;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
          border: isShowMenu ? Border(bottom: const BorderSide()) : null),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                menu.itemName!,
                style: GlobalTextStyles.font16w600ColorBlack,
                textAlign: TextAlign.start,
              )),
          Expanded(
              child: Text(
            "2",
            style: GlobalTextStyles.font16w600ColorBlack,
            textAlign: TextAlign.center,
          )),
          Expanded(
              child: Text(
            "${menu.price! / 1000}K",
            style: GlobalTextStyles.font16w600ColorBlack,
            textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }
}

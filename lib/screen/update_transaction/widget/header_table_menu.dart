import 'package:flutter/material.dart';
import 'package:qlnh/config/global_text_style.dart';

class HeaderTableMenu extends StatelessWidget {
  const HeaderTableMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                "Menu",
                style: GlobalTextStyles.font18w700ColorBlack,
                textAlign: TextAlign.start,
              )),
          Expanded(
              child: Text(
            "Số lượng",
            style: GlobalTextStyles.font18w700ColorBlack,
            textAlign: TextAlign.center,
          )),
          Expanded(
              child: Text(
            "Đơn giá",
            style: GlobalTextStyles.font18w700ColorBlack,
            textAlign: TextAlign.center,
          )),
          Expanded(
              child: Text(
            "TT",
            style: GlobalTextStyles.font18w700ColorBlack,
            textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }
}

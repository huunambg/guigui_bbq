import 'package:flutter/material.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/order_detail.dart';

class ItemMenu extends StatelessWidget {
  const ItemMenu({
    super.key,
    required this.isNotLast,
    required this.menu,
    required this.orderDetail,
  });
  final Menu menu;
  final OrderDetail orderDetail;
  final bool isNotLast;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
          border: isNotLast ? Border(bottom: const BorderSide()) : null),
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
            orderDetail.quantity.toString(),
            style: GlobalTextStyles.font16w600ColorBlack,
            textAlign: TextAlign.center,
          )),
          Expanded(
              child: Text(
            "${(orderDetail.price! / 1000).toInt()}K",
            style: GlobalTextStyles.font16w600ColorBlack,
            textAlign: TextAlign.center,
          )),
          Expanded(
              child: Text(
            "${(orderDetail.totalPrice! / 1000).toInt()}K",
            style: GlobalTextStyles.font16w600ColorBlack,
            textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }
}

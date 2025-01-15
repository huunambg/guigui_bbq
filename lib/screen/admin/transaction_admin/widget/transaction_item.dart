import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/screen/user/table/controller/table_controller.dart';
import 'package:qlnh/util/format_date.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem(
      {super.key, required this.onTap, required this.transaction});
  final GestureTapCallback onTap;
  final Transaction transaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  final tableCtl = Get.find<TableController>();

  Tablee getTable(int id) {
    for (var element in tableCtl.listTable) {
      if (element.tableId == id) {
        return element;
      }
    }
    return Tablee();
  }

  @override
  Widget build(BuildContext context) {
    bool isPaid = widget.transaction.paymentMethod != "Chưa";
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isPaid ? Colors.green[50] : Colors.yellow[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isPaid ? Colors.green : Colors.yellow, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Số bàn: ${getTable(widget.transaction.tableId!).tableName}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Số người: ${widget.transaction.countPeople ?? "Không xác định"}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.date_range, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "Ngày tạo: ${FormatDate().formatDate(widget.transaction.paymentDate)}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPaid
                      ? Icons.check_circle
                      : (widget.transaction.paymentMethod == "Chưa thanh toán"
                          ? Icons.hourglass_empty
                          : Icons.cancel),
                  color: isPaid ? Colors.green : Colors.yellow,
                ),
                const SizedBox(width: 8),
                Text(
                  isPaid ? "Đã thanh toán" : "Chưa thanh toán",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green : Colors.yellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

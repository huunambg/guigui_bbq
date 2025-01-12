import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:intl/intl.dart';
import 'package:qlnh/screen/together/user/add_transaction/widget/header_table_menu.dart';
import 'package:qlnh/screen/together/user/add_transaction/widget/item_menu.dart';
import 'package:qlnh/screen/together/user/menu/controller/menu_controller.dart';
import 'package:qlnh/services/api.dart';
import 'package:qlnh/util/convert.dart';

class DetailTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const DetailTransactionScreen({super.key, required this.transaction});

  @override
  State<DetailTransactionScreen> createState() =>
      _DetailTransactionScreenState();
}

class _DetailTransactionScreenState extends State<DetailTransactionScreen> {
  String _formatDate(String? date) {
    if (date == null) return "Không xác định";
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
    } catch (e) {
      return "Không xác định";
    }
  }

  final menuCtl = Get.find<MenusController>();
  Menu getMenu(int id) {
    int index = menuCtl.listMenu.indexWhere(
      (element) => element.menuId == id,
    );
    if (index != -1) {
      return menuCtl.listMenu[index];
    }
    return Menu();
  }

  List<OrderDetail> listOrderDetail = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    listOrderDetail =
        await ApiService().getOrderDetailByOrder(widget.transaction.orderId!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isPaid = widget.transaction.paymentMethod != "Chưa";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hóa đơn'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Số bàn
            Text(
              "Số bàn: ${widget.transaction.tableId}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Change to black for better visibility
              ),
            ),
            const SizedBox(height: 16),

            // Số người
            Text(
              "Số người: ${widget.transaction.countPeople ?? "Không xác định"}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87,  // Changed to a darker shade for clarity
              ),
            ),
            const SizedBox(height: 16),

            // Ngày tạo
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  "Ngày tạo: ${_formatDate(widget.transaction.paymentDate)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,  // Changed to a darker shade
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Phương thức thanh toán
            Row(
              children: [
                const Icon(Icons.payment, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  "Phương thức thanh toán: ${widget.transaction.paymentMethod}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,  // Changed to a darker shade
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Trạng thái thanh toán
            Row(
              children: [
                Icon(
                  isPaid ? Icons.check_circle : Icons.cancel,
                  color: isPaid ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  isPaid ? "Đã thanh toán" : "Chưa thanh toán",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tổng tiền
            Text(
              "Tổng tiền: ${widget.transaction.amount != null ? tienviet(widget.transaction.amount!) : "Không xác định"}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Changed to black for better visibility
              ),
            ),
            const SizedBox(height: 16),

            // Danh sách món ăn và chi tiết
            Container(
              padding: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blueGrey[50],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const HeaderTableMenu(),
                  listOrderDetail.isNotEmpty
                      ? Column(
                          children: List.generate(
                            listOrderDetail.length,
                            (index) {
                              final item = listOrderDetail[index];
                              return ItemMenu(
                                isNotLast: index != listOrderDetail.length - 1,
                                menu: getMenu(item.menuItemId!),
                                orderDetail: item,
                                ontap: () {},
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Không gọi thêm đồ",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                          ),
                        )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Nút quay lại
            Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .blueAccent, // Use backgroundColor instead of primary
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Quay lại",
                    style: TextStyle(fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/model/user.dart';
import 'package:qlnh/screen/admin/personnel/controller/personnel_controller.dart';
import 'package:qlnh/screen/user/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/screen/user/add_transaction/widget/header_table_menu.dart';
import 'package:qlnh/screen/user/add_transaction/widget/item_menu.dart';
import 'package:qlnh/controller/menu_controller.dart';
import 'package:qlnh/screen/user/table/controller/table_controller.dart';
import 'package:qlnh/services/api.dart';
import 'package:qlnh/util/convert.dart';
import 'package:qlnh/util/format_date.dart';

class DetailTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const DetailTransactionScreen({super.key, required this.transaction});

  @override
  State<DetailTransactionScreen> createState() =>
      _DetailTransactionScreenState();
}

class _DetailTransactionScreenState extends State<DetailTransactionScreen> {
  final tableCtl = Get.find<TableController>();
  final menuCtl = Get.find<MenusController>();
  final addTransactionCtl = Get.find<AddTransactionController>();
  Menu getMenu(int id) {
    int index = menuCtl.listMenu.indexWhere(
      (element) => element.menuId == id,
    );
    if (index != -1) {
      return menuCtl.listMenu[index];
    }
    return Menu();
  }

  Tablee getTable(int id) {
    for (var element in tableCtl.listTable) {
      if (element.tableId == id) {
        return element;
      }
    }
    return Tablee();
  }

  Buffer getBuffer(int id) {
    int index = addTransactionCtl.listBuffer.indexWhere(
      (element) => element.bufferId == id,
    );
    if (index != -1) {
      return addTransactionCtl.listBuffer[index];
    }
    return Buffer();
  }

  List<OrderDetail> listOrderDetail = [];

  User getUser() {
    final userCtl = Get.find<UserController>();
    for (var element in userCtl.listUser) {
      print(element.fullName);
      if (widget.transaction.accountId == element.userId) {
        return element;
      }
    }

    return User(fullName: "Quản lý");
  }

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Số bàn
            Text(
              "Số bàn: ${getTable(widget.transaction.tableId!).tableName}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change to black for better visibility
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person_2_outlined, color: Colors.black),
                const SizedBox(width: 8),
                const Text(
                  "Số người lớn: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color:
                        Colors.black87, // Changed to a darker shade for clarity
                  ),
                ),
                Text(
                  "${widget.transaction.countPeople ?? "Không xác định"}",
                  style: GlobalTextStyles.font16w600ColorBlack,
                )
              ],
            ),
            // Số người
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person_2_outlined, color: Colors.black),
                const SizedBox(width: 8),
                const Text(
                  "Số trẻ em: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color:
                        Colors.black87, // Changed to a darker shade for clarity
                  ),
                ),
                Text(
                  "${widget.transaction.countPeople2 ?? "Không xác định"}",
                  style: GlobalTextStyles.font16w600ColorBlack,
                )
              ],
            ),
            // Số người

            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.food_bank_outlined, color: Colors.black),
                const SizedBox(width: 8),
                const Text(
                  "Loại Buffer: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color:
                        Colors.black87, // Changed to a darker shade for clarity
                  ),
                ),
                Text(
                  getBuffer(widget.transaction.bufferId!).bufferType ??
                      "Không xác định",
                  style: GlobalTextStyles.font16w600ColorBlack,
                )
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.monetization_on_outlined, color: Colors.black),
                const SizedBox(width: 8),
                const Text(
                  "Giá Buffer: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color:
                        Colors.black87, // Changed to a darker shade for clarity
                  ),
                ),
                Text(
                  "NL ${tienviet(getBuffer(widget.transaction.bufferId!).pricePerPerson!)} - TE ${tienviet(getBuffer(widget.transaction.bufferId!).pricePerPerson2!)}",
                  style: GlobalTextStyles.font16w600ColorBlack,
                )
              ],
            ),
            const SizedBox(height: 16),

            // Ngày tạo
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  "Ngày tạo: ${FormatDate().formatDate(widget.transaction.paymentDate)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87, // Changed to a darker shade
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
                const Text(
                  "PT thanh toán: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87, // Changed to a darker shade
                  ),
                ),
                Text(
                  convertPaymentMethod(widget.transaction.paymentMethod!),
                  style: GlobalTextStyles.font16w600ColorBlack,
                )
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.discount_rounded, color: Colors.black),
                const SizedBox(width: 8),
                const Text(
                  "Mã giảm giá: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87, // Changed to a darker shade
                  ),
                ),
                Text(
                  widget.transaction.discountCode != ""
                      ? widget.transaction.discountCode!
                      : "Không có",
                  style: GlobalTextStyles.font16w600ColorBlack,
                )
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
                color: Colors.black, // Changed to black for better visibility
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.person_3_outlined, color: Colors.black),
                const SizedBox(width: 8),
                const Text(
                  "Nhân viên: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color:
                        Colors.black87, // Changed to a darker shade for clarity
                  ),
                ),
                Text(
                  getUser().fullName!,
                  style: GlobalTextStyles.font16w600ColorBlack,
                )
              ],
            ),
            const SizedBox(height: 16),
            // Danh sách món ăn và chi tiết
            Container(
              padding: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blueGrey[50],
                boxShadow: const [
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
          ],
        ),
      ),
    );
  }

  String convertPaymentMethod(String pt) {
    if (pt == "TM") {
      return "Tiền mặt";
    } else if (pt == "CK") {
      return "Chuyển khoản";
    } else {
      return "Chưa thanh toán";
    }
  }
}

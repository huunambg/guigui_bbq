import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/orders.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/screen/together/user/menu/menu_screen.dart';
import 'package:qlnh/screen/together/user/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/screen/together/user/add_transaction/widget/bottom_sheet_update_menu.dart';
import 'package:qlnh/screen/together/user/add_transaction/widget/header_table_menu.dart';
import 'package:qlnh/screen/together/user/add_transaction/widget/item_menu.dart';
import 'package:qlnh/screen/together/user/menu/controller/menu_controller.dart';
import 'package:qlnh/screen/together/user/update_transaction/controller/update_transaction_controller.dart';
import 'package:qlnh/services/api.dart';
import 'package:qlnh/util/convert.dart';
import 'package:qlnh/widget/body_background.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UpdateTransactionScreen extends StatefulWidget {
  const UpdateTransactionScreen(
      {super.key, required this.table, required this.idTableFB});
  final Tablee table;
  final String idTableFB;
  @override
  State<UpdateTransactionScreen> createState() =>
      _UpdateTransactionScreenState();
}

class _UpdateTransactionScreenState extends State<UpdateTransactionScreen> {
  List<String> items = [];
  String? selectedValue;
  Buffer? selectedBuffer;
  final updateTransactionCtl = Get.find<UpdateTransactionController>();
  final addTransactionCtl = Get.find<AddTransactionController>();
  final menuCtl = Get.find<MenusController>();
  int selectPayment = 0;

  @override
  void initState() {
    super.initState();
    items = List.generate(
      widget.table.capacity!,
      (index) {
        return (index + 1).toString();
      },
    ).toList();
    updateTransactionCtl.initUpdate(widget.table.tableId!).whenComplete(
      () {
        selectedValue = updateTransactionCtl.selectNumberPeople.value;
        selectedBuffer = updateTransactionCtl.selectBuffer.value;
        selectPayment =
            updateTransactionCtl.transaction.value.paymentMethod == "Chưa"
                ? 0
                : updateTransactionCtl.transaction.value.paymentMethod == "TM"
                    ? 1
                    : 2;
        updateTransactionCtl.selectPayment.value = selectPayment;
        setState(() {});
      },
    );
  }

  Menu getMenu(int id) {
    int index = menuCtl.listMenu.indexWhere(
      (element) => element.menuId == id,
    );
    if (index != -1) {
      return menuCtl.listMenu[index];
    }
    return Menu();
  }

  @override
  void dispose() {
    updateTransactionCtl.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bàn ${widget.table.tableName}"),
        actions: [
          Obx(
            () => updateTransactionCtl.isShowQR.value &&
                    updateTransactionCtl.totalMoney.value > 0
                ? TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: AspectRatio(
                            aspectRatio: 600 / 776,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Stack(
                                children: [
                                  Image.network(
                                      "https://img.vietqr.io/image/vietinbank-107872416964-print.jpg?amount=${updateTransactionCtl.totalMoney}&addInfo=Thanh toan tien ban ${widget.table.tableName}&accountName=Nong Huu Nam"),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "QR thanh toán",
                      style: TextStyle(color: Colors.blue),
                    ))
                : const SizedBox(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Số lượng người",
              style: GlobalTextStyles.font16w600ColorBlack,
            ),
            const Gap(8.0),
            dropdownButtonSelectNumberPeole(),
            const Gap(8.0),
            Text(
              "Loại Buffer",
              style: GlobalTextStyles.font16w600ColorBlack,
            ),
            const Gap(8.0),
            dropdownButtonSelectBuffer(),
            const Gap(8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Đồ gọi thêm",
                  style: GlobalTextStyles.font16w600ColorBlack,
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.to(MenuScreen(
                        order: Orders(),
                        isUpdate: true,
                      ));
                    },
                    child: const Text("Thêm"))
              ],
            ),
            const Gap(8.0),
            Container(
              padding: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: [
                  const HeaderTableMenu(),
                  Obx(() => updateTransactionCtl.listOrderDetail.isNotEmpty
                      ? Column(
                          children: List.generate(
                            updateTransactionCtl.listOrderDetail.length,
                            (index) {
                              final item =
                                  updateTransactionCtl.listOrderDetail[index];
                              return ItemMenu(
                                isNotLast: index !=
                                    updateTransactionCtl
                                            .listOrderDetail.length -
                                        1,
                                menu: getMenu(item.menuItemId!),
                                orderDetail: item,
                                ontap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => BottomSheetUpdateMenu(
                                      menu: getMenu(item.menuItemId!),
                                      quantity: item.quantity!,
                                      onAdd: (value) {
                                        if (value == 0) {
                                          ApiService().deleteOrderDetail(
                                              item.orderDetailId!);
                                          updateTransactionCtl.listOrderDetail
                                              .removeAt(index);
                                          updateTransactionCtl
                                              .updateTotalMoney();
                                          return;
                                        }
                                        updateTransactionCtl
                                                .listOrderDetail[index] =
                                            updateTransactionCtl
                                                .listOrderDetail[index]
                                                .copyWith(
                                                    quantity: value,
                                                    totalPrice:
                                                        value * item.price!);
                                        updateTransactionCtl.updateTotalMoney();
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Không gọi thêm đồ"),
                          ),
                        ))
                ],
              ),
            ),
            const Gap(8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng tiền phải trả",
                  style: GlobalTextStyles.font16w600ColorBlack,
                ),
                const Gap(8.0),
                Obx(
                  () => Text(
                    tienviet(updateTransactionCtl.totalMoney.value),
                    style: GlobalTextStyles.font18w700ColorBlack
                        .copyWith(color: Colors.red),
                  ),
                ),
              ],
            ),
            const Gap(8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Thanh toán",
                  style: GlobalTextStyles.font16w600ColorBlack,
                ),
                ToggleSwitch(
                  activeBgColor: [
                    GlobalColors.primary, // Màu cho tùy chọn "CK"
                  ],
                  initialLabelIndex: selectPayment,
                  totalSwitches: 3,
                  labels: const ['Chưa', 'TM', 'CK'],
                  onToggle: (index) {
                    updateTransactionCtl.selectPayment.value = index!;
                    selectPayment = index;
                    if (index == 2) {
                      updateTransactionCtl.isShowQR.value = true;
                    } else {
                      updateTransactionCtl.isShowQR.value = false;
                    }
                  },
                )
              ],
            ),
            const Gap(16.0),
            // Obx(
            //   () => updateTransactionCtl.isShowQR.value &&
            //           updateTransactionCtl.totalMoney.value > 0
            //       ? AspectRatio(
            //           aspectRatio: 600 / 776,
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(14),
            //             child: Image.network(
            //                 "https://img.vietqr.io/image/vietinbank-107872416964-print.jpg?amount=${updateTransactionCtl.totalMoney}&addInfo=Thanh toan tien ban ${widget.table.tableName}&accountName=Nong Huu Nam"),
            //           ),
            //         )
            //       : const SizedBox(),
            // ),

            Obx(
              () => updateTransactionCtl.selectPayment.value > 0
                  ? Row(
                      children: [
                        Text(
                          "Đã ăn xong",
                          style: GlobalTextStyles.font16w600ColorBlack,
                        ),
                        Checkbox(
                          value: updateTransactionCtl.isFinish.value,
                          onChanged: (value) {
                            updateTransactionCtl.isFinish.value = value!;
                          },
                        )
                      ],
                    )
                  : const SizedBox(),
            ),

            const Gap(24.0),
            MaterialButton(
              onPressed: () {
                final transaction = Transaction(
                  tableId: widget.table.tableId,
                  bufferId: selectedBuffer!.bufferId,
                  amount: updateTransactionCtl.totalMoney.value,
                  paymentMethod: selectPayment == 0
                      ? "Chưa"
                      : selectPayment == 1
                          ? "TM"
                          : "CK",
                  countPeople:
                      int.parse(updateTransactionCtl.selectNumberPeople.value),
                  accountId: 1,
                  orderId: updateTransactionCtl.transaction.value.orderId,paymentDate: DateTime.now().toString()
                );
                updateTransactionCtl.updateTransaction(
                    transaction, context, widget.idTableFB);
              },
              minWidth: double.infinity,
              height: 56.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: GlobalColors.primary,
              child: Text(
                "Cập nhật hóa đơn",
                style: GlobalTextStyles.font16w600ColorWhite,
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget dropdownButtonSelectNumberPeole() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.black,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                'Chọn số lượng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    "$item người",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          updateTransactionCtl.updateSelectNumberPeople(value!);
          setState(() {
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }

  Widget dropdownButtonSelectBuffer() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Buffer>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.black,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                'Chọn Buffer',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: addTransactionCtl.listBuffer
            .map((Buffer item) => DropdownMenuItem<Buffer>(
                  value: item,
                  child: Text(
                    "${item.bufferType} ${(item.pricePerPerson! / 1000).toInt()}K",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedBuffer,
        onChanged: (value) {
          updateTransactionCtl.updateSelectBuffer(value!);
          setState(() {
            selectedBuffer = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
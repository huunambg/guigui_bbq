import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/orders.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/screen/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/screen/add_transaction/widget/item_menu.dart';
import 'package:qlnh/screen/menu/menu_screen.dart';
import 'package:qlnh/widget/body_background.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, required this.table});
  final Tablee table;
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  List<String> items = [];
  String? selectedValue;
  Buffer? selectedBuffer;
  final addTransactionCtl = Get.find<AddTransactionController>();

  @override
  void initState() {
    addTransactionCtl.getListBuffer();
    super.initState();
    items = List.generate(
      widget.table.capacity!,
      (index) {
        return (index + 1).toString();
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.table.tableName!),
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
                const Text("Đồ gọi thêm"),
                ElevatedButton(
                    onPressed: () {
                      Get.to(MenuScreen(order: Orders(),));
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide())),
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
                        ))
                      ],
                    ),
                  ),
                  ItemMenu(
                    menu: Menu(itemName: "Cocacola", price: 10000),
                    isShowMenu: true,
                  ),
                  ItemMenu(
                    menu: Menu(itemName: "Rượu vang đỏ", price: 200000),
                    isShowMenu: false,
                  ),
                ],
              ),
            ),
            Gap(24.0),
            MaterialButton(
              onPressed: () {},
              minWidth: double.infinity,
              height: 56.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: GlobalColors.primary,
              child: Text(
                "Tạo hóa đơn",
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
                    "${item.bufferType}",
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
}

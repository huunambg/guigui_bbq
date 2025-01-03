import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/api_state.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/orders.dart';
import 'package:qlnh/screen/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/screen/menu/controller/menu_controller.dart';
import 'package:qlnh/screen/menu/widget/bottom_sheet_menu.dart';
import 'package:qlnh/widget/body_background.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.order});
  final Orders order;
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final addTransactionCtl = Get.find<AddTransactionController>();
  final menuCtl = Get.find<MenusController>();
  @override
  void initState() {
    super.initState();
    menuCtl.getListMenu();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Menu"),
            ),
            body: Obx(
              () {
                if (menuCtl.apiState.value == ApiState.failure) {
                  return const Text("Error");
                } else if (menuCtl.apiState.value == ApiState.success) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8.0,
                    ),
                    itemCount: menuCtl.listMenu.length,
                    itemBuilder: (context, index) {
                      Menu menu = menuCtl.listMenu[index];
                      return Container(
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => BottomSheetMenu(
                                  menu: menu,
                                  onAdd: (value) {
                                    addTransactionCtl.addOrderDetail(
                                        OrderDetail(
                                            orderId: widget.order.orderId,
                                            menuItemId: menu.menuId,
                                            price: menu.price!,
                                            quantity: value,
                                            totalPrice: menu.price! * value));
                                  },
                                ),
                              );
                            },
                            leading: const Icon(Icons.access_alarm),
                            title: Text(menu.itemName!),
                            subtitle: Text(menu.price!.toString()),
                          ));
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )));
  }
}

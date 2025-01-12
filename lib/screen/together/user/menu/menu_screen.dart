import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/api_state.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/orders.dart';
import 'package:qlnh/screen/together/user/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/screen/together/user/menu/controller/menu_controller.dart';
import 'package:qlnh/screen/together/user/menu/widget/bottom_sheet_menu.dart';
import 'package:qlnh/screen/together/user/update_transaction/controller/update_transaction_controller.dart';
import 'package:qlnh/util/convert.dart';
import 'package:qlnh/widget/body_background.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.order, required this.isUpdate});
  final Orders order;
  final bool isUpdate;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final addTransactionCtl = Get.find<AddTransactionController>();
  final updateTransactionCtl = Get.find<UpdateTransactionController>();
  final menuCtl = Get.find<MenusController>();
  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Menu", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Obx(
          () {
            if (menuCtl.apiState.value == ApiState.failure) {
              return const Center(child: Text("Error", style: TextStyle(color: Colors.red, fontSize: 18.0)));
            } else if (menuCtl.apiState.value == ApiState.success) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                separatorBuilder: (context, index) => const SizedBox(height: 12.0),
                itemCount: menuCtl.listMenu.length,
                itemBuilder: (context, index) {
                  Menu menu = menuCtl.listMenu[index];
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => BottomSheetMenu(
                          menu: menu,
                          onAdd: (value) {
                            if (widget.isUpdate) {
                              updateTransactionCtl.addOrderDetail(
                                OrderDetail(
                                  orderId: widget.order.orderId,
                                  menuItemId: menu.menuId,
                                  price: menu.price!,
                                  quantity: value,
                                  totalPrice: menu.price! * value,
                                ),
                              );
                            } else {
                              addTransactionCtl.addOrderDetail(
                                OrderDetail(
                                  orderId: widget.order.orderId,
                                  menuItemId: menu.menuId,
                                  price: menu.price!,
                                  quantity: value,
                                  totalPrice: menu.price! * value,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(Icons.restaurant_menu, color: Colors.white,size: 30,),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu.itemName!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  tienviet(menu.price!),
                                  style: const TextStyle(color: Colors.grey, fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.orangeAccent),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => BottomSheetMenu(
                                  menu: menu,
                                  onAdd: (value) {
                                    if (widget.isUpdate) {
                                      updateTransactionCtl.addOrderDetail(
                                        OrderDetail(
                                          orderId: widget.order.orderId,
                                          menuItemId: menu.menuId,
                                          price: menu.price!,
                                          quantity: value,
                                          totalPrice: menu.price! * value,
                                        ),
                                      );
                                    } else {
                                      addTransactionCtl.addOrderDetail(
                                        OrderDetail(
                                          orderId: widget.order.orderId,
                                          menuItemId: menu.menuId,
                                          price: menu.price!,
                                          quantity: value,
                                          totalPrice: menu.price! * value,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

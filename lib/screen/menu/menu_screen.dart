import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/model/order_detail.dart';
import 'package:qlnh/model/orders.dart';
import 'package:qlnh/screen/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/screen/menu/widget/bottom_sheet_menu.dart';
import 'package:qlnh/services/api.dart';
import 'package:qlnh/widget/body_background.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.order});
  final Orders order;
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final addTransactionCtl = Get.find<AddTransactionController>();
  @override
  Widget build(BuildContext context) {
    return BodyCustom(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Menu"),
      ),
      body: FutureBuilder(
        future: ApiService().getAllMenu(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          } else if (snapshot.hasData) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              separatorBuilder: (context, index) => const SizedBox(
                height: 8.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Menu menu = snapshot.data![index];
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
                                  OrderDetail(orderId: widget.order.orderId));
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
      ),
    ));
  }
}

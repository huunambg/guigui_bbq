import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/screen/together/user/update_transaction/update_transaction_screen.dart';
import 'package:qlnh/screen/together/user/add_transaction/add_transaction_screen.dart';
import 'package:qlnh/screen/together/user/add_transaction/controller/add_transaction_controller.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final _streamTable =
      FirebaseFirestore.instance.collection("Table").snapshots();
  final _docsTable = FirebaseFirestore.instance.collection("Table");

  int countAvailableTable(List data) {
    int cnt = 0;
    if (data.isNotEmpty) {
      for (var table in data) {
        if (table['status'] == "Available") {
          cnt++;
        }
      }
    }
    return cnt;
  }

  final addTransactionCtl = Get.find<AddTransactionController>();
  @override
  void initState() {
    super.initState();
    addTransactionCtl.getListBuffer();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Tổng số bàn trống: "),
            StreamBuilder(
              stream: _streamTable,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listTable = snapshot.data!.docs;
                  return Text(countAvailableTable(listTable).toString());
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _streamTable,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listTable = snapshot.data!.docs;
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: listTable.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                final table = Tablee.fromJson(listTable[index].data());

                return GestureDetector(
                  onTap: () {
                    if (table.status == "Available") {
                      Get.to(AddTransactionScreen(
                          table: table, idTableFB: listTable[index].id));
                    } else if (table.status == "Occupied") {
                      Get.to(UpdateTransactionScreen(
                          table: table, idTableFB: listTable[index].id));
                    }
                  },
                  onLongPress: () {
                    _docsTable.doc(listTable[index].id).update({
                      'status': "Available",
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: table.status == "Available"
                                  ? Colors.green[300]
                                  : table.status == "Occupied"
                                      ? Colors.orange[300]
                                      : Colors.red[300],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Column(
                            children: [
                              Icon(
                                table.status == "Available"
                                    ? Icons.event_seat
                                    : table.status == "Occupied"
                                        ? Icons.people
                                        : Icons.error,
                                color: Colors.white,
                                size: 32,
                              ),
                              Text(
                                table.tableName.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.chair, size: 16),
                                  const SizedBox(width: 4),
                                  const Text("Số ghế: ",
                                      style: TextStyle(fontSize: 12)),
                                  Text(table.capacity.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.info, size: 16),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      statusTableConvert(table.status.toString()),
                                     style: GlobalTextStyles.font12w600ColorBlack,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  String statusTableConvert(String status) {
    if (status == "Available") {
      return "Trống";
    } else if (status == "Occupied") {
      return "Đã có khách";
    } else {
      return "Đang lỗi";
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/screen/add_transaction/add_transaction_screen.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final _streamTable =
      FirebaseFirestore.instance.collection("Table").snapshots();
  final _docsTable = FirebaseFirestore.instance.collection("Table");
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    // double w = MediaQuery.of(context).size.width;

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
                  print(listTable);
                  return Text(countAvailableTable(listTable).toString());
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
            print(listTable);
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: listTable.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                final table = Tablee.fromJson(listTable[index].data());

                return GestureDetector(
                  onTap: () {
                    // _docsTable.doc(table.id).update({
                    //   'status': "Available",
                    // });
                    Get.to(AddTransactionScreen(table: table));
                  },
                  onLongPress: () {
                    // _docsTable.doc(table.id).update({
                    //   'status': "Fixing",
                    // });
                  },
                  onDoubleTap: () {
                    // _docsTable.doc(table.id).update({
                    //   'status': "Occupied",
                    // });
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
                                  ? Colors.blue
                                  : table.status == "Occupied"
                                      ? Colors.yellow
                                      : Colors.red,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Text(
                            table.tableName.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text("Số người: ",
                                      style: TextStyle(fontSize: 12)),
                                  Text(table.capacity.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                children: [
                                  // Text("Status: ",
                                  //     style: TextStyle(fontSize: 12)),
                                  Text(
                                      statusTableConvert(
                                          table.status.toString()),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
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

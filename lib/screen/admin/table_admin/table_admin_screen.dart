import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/screen/admin/add_table/add_table_screen.dart';
import 'package:qlnh/screen/user/update_transaction/update_transaction_screen.dart';
import 'package:qlnh/screen/user/add_transaction/add_transaction_screen.dart';
import 'package:qlnh/screen/user/add_transaction/controller/add_transaction_controller.dart';
import 'package:qlnh/services/api.dart';

class TableAdminScreen extends StatefulWidget {
  const TableAdminScreen({super.key});

  @override
  State<TableAdminScreen> createState() => _TableAdminScreenState();
}

class _TableAdminScreenState extends State<TableAdminScreen> {
  final _streamTable =
      FirebaseFirestore.instance.collection("Table").snapshots();
  final _docsTable = FirebaseFirestore.instance.collection("Table");
  final phoneCtl = TextEditingController();
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
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(AddTableScreen());
            },
            child: const Icon(
              Icons.add,
              size: 28,
            ),
          ),
          const Gap(12.0)
        ],
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
                  childAspectRatio: 0.8,
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
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
                    } else if (table.status == "Booked") {
                      CherryToast.warning(
                        title: const Text("Hiện tại bàn đã có khách order"),
                      ).show(context);
                    } else {
                      CherryToast.error(
                        title:
                            const Text("Hiện tại bàn đang lỗi không thể Order"),
                      ).show(context);
                    }
                  },
                  onLongPress: () {
                    // _docsTable.doc(listTable[index].id).update({
                    //   'status': "Available",
                    // });

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actionsPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          insetPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: const Text("Chọn chức năng"),
                          content: const Text("Mời bạn chọn chức năng bàn"),
                          actions: [
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      if (table.status == "Booked") {
                                        await _docsTable
                                            .doc(listTable[index].id)
                                            .update({"status": "Available"});
                                        return;
                                      }
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                actionsPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 20),
                                                insetPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                title: const Text("Đặt bàn"),
                                                content: TextField(
                                                  controller: phoneCtl,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Nhập số điện thoại",
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20))),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        Get.back();
                                                        await _docsTable
                                                            .doc(
                                                                listTable[index]
                                                                    .id)
                                                            .update({
                                                          "status": "Booked",
                                                          "phone": phoneCtl.text
                                                        });
                                                      },
                                                      child: const Text(
                                                          "Đặt bàn")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                          "Quay lại"))
                                                ]);
                                          });
                                    },
                                    child: const Text("Đặt bàn")),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                      PanaraConfirmDialog.show(
                                        context,
                                        title:
                                            "Cập nhật bàn ${table.tableName} tạm hỏng",
                                        message:
                                            "Bạn có cập nhật trạng thái cho bàn trên",
                                        confirmButtonText: "Cập nhật",
                                        cancelButtonText: "Quay lại",
                                        onTapCancel: () {
                                          Get.back();
                                        },
                                        onTapConfirm: () async {
                                          Get.back();
                                          if (table.status == "Reserved") {
                                            await _docsTable
                                                .doc(listTable[index].id)
                                                .update(
                                                    {"status": "Available"});
                                          } else {
                                            await _docsTable
                                                .doc(listTable[index].id)
                                                .update({"status": "Reserved"});
                                          }
                                          phoneCtl.clear();
                                        },
                                        panaraDialogType:
                                            PanaraDialogType.warning,
                                        barrierDismissible: false,
                                      );
                                    },
                                    child: const Text("Tạm hỏng")),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                      PanaraConfirmDialog.show(
                                        context,
                                        title: "Xóa bàn ${table.tableName}",
                                        message:
                                            "Bạn có xóa bàn khỏi danh sách",
                                        confirmButtonText: "Xóa",
                                        cancelButtonText: "Quay lại",
                                        onTapCancel: () {
                                          Get.back();
                                        },
                                        onTapConfirm: () async {
                                          Get.back();
                                          await ApiService()
                                              .deleteTable(table.tableId!);
                                          await _docsTable
                                              .doc(listTable[index].id)
                                              .delete();
                                          CherryToast.success(
                                            title: const Text(
                                                "Xóa thành công bàn"),
                                          ).show(context);
                                        },
                                        panaraDialogType:
                                            PanaraDialogType.warning,
                                        barrierDismissible: false,
                                      );
                                    },
                                    child: const Text("Xóa bàn")),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("Quay lại")),
                              ],
                            )
                          ],
                        );
                      },
                    );
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
                                      : table.status == "Booked"
                                          ? Colors.pinkAccent
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
                              const EdgeInsets.only(top: 4, left: 4, right: 4),
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
                                      statusTableConvert(
                                          table.status.toString()),
                                      style:
                                          GlobalTextStyles.font12w600ColorBlack,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (table.status == "Booked")
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 8, right: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.phone, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    listTable[index].data()['phone'].toString(),
                                    style:
                                        GlobalTextStyles.font12w600ColorBlack,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
    } else if (status == "Booked") {
      return "Khách đặt";
    } else {
      return "Đang lỗi";
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlnh/config/api_state.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/screen/together/user/detail_transaction/detail_transaction.dart';
import 'package:qlnh/screen/together/user/transaction/controller/transaction_controller.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final transactionCtl = Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    transactionCtl.getListTransaction();
  }

  Future<void> _refreshTransactions() async {
    transactionCtl.getListTransaction();
  }

  String _formatDate(String? date) {
    if (date == null) return "Không xác định";
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
    } catch (e) {
      return "Không xác định";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hóa đơn",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (transactionCtl.apiState.value) {
          case ApiState.loading:
            return const Center(child: CircularProgressIndicator());
          case ApiState.success:
            if (transactionCtl.listTransaction.isEmpty) {
              return const Center(
                child: Text(
                  "Không có hóa đơn nào.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: _refreshTransactions,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: transactionCtl.listTransaction.length,
                itemBuilder: (context, index) {
                  Transaction transaction =
                      transactionCtl.listTransaction[index];
                  bool isPaid = transaction.paymentMethod != "Chưa";

                  return GestureDetector(
                    onTap: () => Get.to(DetailTransactionScreen(
                      transaction: transaction,
                    )),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isPaid ? Colors.green[50] : Colors.yellow[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isPaid ? Colors.green : Colors.yellow,
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Số bàn: ${transaction.tableId}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Số người: ${transaction.countPeople ?? "Không xác định"}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.date_range,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                "Ngày tạo: ${_formatDate(transaction.paymentDate)}",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                isPaid
                                    ? Icons.check_circle
                                    : (transaction.paymentMethod ==
                                            "Chưa thanh toán"
                                        ? Icons.hourglass_empty
                                        : Icons.cancel),
                                color: isPaid ? Colors.green : Colors.yellow,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isPaid ? "Đã thanh toán" : "Chưa thanh toán",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isPaid ? Colors.green : Colors.yellow,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          default:
            return const Center(
              child: Text(
                "Lỗi kết nối, vui lòng thử lại sau.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
        }
      }),
    );
  }
}

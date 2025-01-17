import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/screen/user/transaction/controller/transaction_controller.dart';
import 'package:qlnh/util/convert.dart';
import 'package:qlnh/util/format_date.dart';

class TransactionStatisticsScreen extends StatefulWidget {
  @override
  _TransactionStatisticsScreenState createState() =>
      _TransactionStatisticsScreenState();
}

class _TransactionStatisticsScreenState
    extends State<TransactionStatisticsScreen> {
  List<Transaction> transactions = [];
  String? selectedMonth;
  String? selectedYear;
  List<Transaction> filteredTransactions = [];
  int totalTransactions = 0;
  int totalAmount = 0;
  final transactionCtl = Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    transactions = transactionCtl.listTransaction;
    print("Transactions: ${transactionCtl.listTransaction}");
    filteredTransactions = transactions;
    calculateStatistics();
  }

  void filterTransactions() {
    setState(() {
      filteredTransactions = transactions.where((transaction) {
        final paymentDate = transaction.paymentDateAsDateTime;
        if (paymentDate == null) return false;

        // Định dạng tháng thành 2 chữ số để so sánh
        final matchesMonth = selectedMonth == null ||
            selectedMonth == 'all' ||
            paymentDate.month.toString().padLeft(2, '0') == selectedMonth;

        final matchesYear = selectedYear == null ||
            selectedYear == 'all' ||
            paymentDate.year.toString() == selectedYear;

        return matchesMonth && matchesYear;
      }).toList();
      calculateStatistics();
    });
  }

  void calculateStatistics() {
    totalTransactions = filteredTransactions.length;
    totalAmount = filteredTransactions.fold(
        0, (sum, transaction) => sum + (transaction.amount ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thống kê"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedMonth,
                    hint: const Text("Chọn Tháng"),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: 'all',
                        child: Text("Tất cả các tháng"),
                      ),
                      ...List.generate(12, (index) {
                        final month = (index + 1).toString().padLeft(2, '0');
                        return DropdownMenuItem(
                          value: month,
                          child: Text("Tháng $month"),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                        print("Selected Month: $selectedMonth"); // Debug
                        filterTransactions();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedYear,
                    hint: const Text("Chọn Năm"),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: 'all',
                        child: Text("Tất cả các năm"),
                      ),
                      ...List.generate(
                        5, // Hiển thị 20 năm
                        (index) {
                          final year =
                              (DateTime.now().year - 1 + index).toString();
                          return DropdownMenuItem(
                            value: year,
                            child: Text("Năm $year"),
                          );
                        },
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                        print("Selected Year: $selectedYear"); // Debug
                        filterTransactions();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Thống kê",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tổng số giao dịch:"),
                        Text(
                          "$totalTransactions",
                          style: GlobalTextStyles.font14w600ColorBlack,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tổng số tiền:"),
                        Text(
                          tienviet(totalAmount),
                          style: GlobalTextStyles.font14w600ColorBlack,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(
                          Icons.attach_money,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "Số tiền: + ${tienviet(transaction.amount!)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        "Thời gian: ${FormatDate().formatDate(transaction.paymentDate)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[700],
                        size: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension DateParsing on Transaction {
  DateTime? get paymentDateAsDateTime {
    if (paymentDate == null) return null;
    try {
      return DateTime.parse(paymentDate!);
    } catch (e) {
      return null;
    }
  }
}

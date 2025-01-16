import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/screen/user/transaction/controller/transaction_controller.dart';

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
    filteredTransactions = transactions;
    calculateStatistics();
  }

  void filterTransactions() {
    setState(() {
      filteredTransactions = transactions.where((transaction) {
        final paymentDate = transaction.paymentDateAsDateTime;
        if (paymentDate == null) return false;

        final matchesMonth = selectedMonth == null ||
            selectedMonth == 'all' ||
            paymentDate.month.toString() == selectedMonth;
        final matchesYear =
            selectedYear == null || paymentDate.year.toString() == selectedYear;

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
        title: Text(
          "Thống kê",
        ),
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
                    hint: Text("Chọn Tháng"),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
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
                        filterTransactions();
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedYear,
                    hint: Text("Chọn Năm"),
                    isExpanded: true,
                    items: [
                      "2023",
                      "2024",
                      "2025",
                    ].map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text("Năm $year"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
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
                    Text(
                      "Thống kê",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tổng số giao dịch:"),
                        Text("$totalTransactions"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tổng số tiền:"),
                        Text("\$$totalAmount"),
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
                return ListTile(
                  title: Text("Số tiền: ${transaction.amount}"),
                  subtitle: Text("Ngày: ${transaction.paymentDate}"),
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

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:qlnh/config/api_state.dart';
import 'package:qlnh/model/transaction.dart';
import 'package:qlnh/screen/admin/transaction_admin/widget/transaction_item.dart';
import 'package:qlnh/screen/together/detail_transaction/detail_transaction.dart';
import 'package:qlnh/screen/user/transaction/controller/transaction_controller.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class TransactionAdminScreen extends StatefulWidget {
  const TransactionAdminScreen({super.key});

  @override
  State<TransactionAdminScreen> createState() => _TransactionAdminScreenState();
}

class _TransactionAdminScreenState extends State<TransactionAdminScreen> {
  final transactionCtl = Get.find<TransactionController>();
  late SwipeActionController controller;
  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    transactionCtl.getListTransaction();
    controller = SwipeActionController(selectedIndexPathsChangeCallback:
        (changedIndexPaths, selected, currentCount) {
      setState(() {});
    });
  }



  Future<void> _refreshTransactions() async {
    transactionCtl.getListTransaction();
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
        actions: [
          GestureDetector(
            onTap: () async {
              transactionCtl.getListTransaction();
            },
            child: const Icon(
              Icons.replay_outlined,
              size: 28,
            ),
          ),
          const Gap(12.0),
          GestureDetector(
            onTap: () async {
              var results = await showCalendarDatePicker2Dialog(
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.single,
                    currentDate: currentDate),
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
              );
              try {
                if (results!.isNotEmpty) {
                  currentDate = results.first!;
                  transactionCtl.getListTransactionByDate(results.first!);
                }
              } catch (e) {}
            },
            child: const Icon(
              Icons.calendar_month,
              size: 28,
            ),
          ),
          const Gap(12.0)
        ],
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
              child: ListView.separated(
                padding: const EdgeInsets.all(16.0),
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: transactionCtl.listTransaction.length,
                itemBuilder: (context, index) {
                  return item(context, index);
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

  Widget item(BuildContext ctx, int index) {
    Transaction transaction = transactionCtl.listTransaction[index];

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: SwipeActionCell(
          controller: controller,
          index: index,
          // Required!
          key: ValueKey(transaction),
          selectedForegroundColor: Colors.black.withAlpha(30),
          trailingActions: [
            SwipeAction(
                backgroundRadius: 8.0,
                title: "Xóa",
                closeOnTap: true,
                onTap: (handler) async {
                  PanaraConfirmDialog.show(
                    context,
                    title: "Xóa giao dịch",
                    message: "Bạn có xóa giao địch ra khỏi danh sách",
                    confirmButtonText: "Xóa",
                    cancelButtonText: "Quay lại",
                    onTapCancel: () {
                      Get.back();
                    },
                    onTapConfirm: () {
                      Get.back();
                      transactionCtl
                          .deleteTransaction(transaction.transactionId!)
                          .then(
                        (value) {
                          CherryToast.success(
                            title: const Text("Đã xóa giao dịch"),
                          ).show(context);
                        },
                      ).catchError((e) {
                        CherryToast.success(
                          title: const Text("Xóa giao dịch thất bại"),
                        ).show(context);
                      });
                    },
                    panaraDialogType: PanaraDialogType.warning,
                    barrierDismissible: false,
                  );
                }),
          ],
          child: TransactionItem(
              onTap: () {
                Get.to(() => DetailTransactionScreen(transaction: transaction));
              },
              transaction: transaction)),
    );
  }
}

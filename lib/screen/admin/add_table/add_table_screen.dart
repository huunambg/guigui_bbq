import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/controller/menu_controller.dart';
import 'package:qlnh/model/table.dart';
import 'package:qlnh/services/api.dart';

class AddTableScreen extends StatefulWidget {
  @override
  _AddTableScreenState createState() => _AddTableScreenState();
}

class _AddTableScreenState extends State<AddTableScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final menuCtl = Get.find<MenusController>();
  final tableDocs = FirebaseFirestore.instance.collection("Table");

  Future<void> createTable() async {
    if (_formKey.currentState!.validate()) {
      Tablee table = Tablee(
          tableName: _itemNameController.text,
          capacity: int.parse(_capacityController.text));
      try {
        int tabeId = await ApiService().addTable(table);
        print(tabeId);
        if (tabeId != 0) {
          await tableDocs.add({
            'table_id': tabeId,
            'status': 'Available',
            'table_name': _itemNameController.text,
            'capacity': int.parse(_capacityController.text)
          });
          CherryToast.success(
            title: Text("Thêm bàn thành công"),
          ).show(context);
          setState(() {
            _itemNameController.text = '';
            _capacityController.text = '';
          });
        }
      } catch (e) {
        CherryToast.error(
          title: Text("Thêm bàn thất baij"),
        ).show(context);
      }
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm bàn ăn',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Text(
                  "Số bàn",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên bàn',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.table_bar_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng tên bàn';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Số lượng người tối đa",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _capacityController,
                  decoration: InputDecoration(
                    hintText: 'Nhập số lượng',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person_2_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng số lượng';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Số lượng phải là số';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      createTable();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text('Thêm bàn',
                        style: GlobalTextStyles.font16w600ColorWhite
                            .copyWith(color: Colors.white.withOpacity(.9))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

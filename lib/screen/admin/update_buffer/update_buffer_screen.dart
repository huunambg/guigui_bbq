import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/buffer.dart';
import 'package:qlnh/screen/admin/buffer_admin/controller/buffer_controller.dart';

class UpdateBufferScreen extends StatefulWidget {
  const UpdateBufferScreen({super.key, required this.buffer});
  final Buffer buffer;
  @override
  _UpdateBufferScreenState createState() => _UpdateBufferScreenState();
}

class _UpdateBufferScreenState extends State<UpdateBufferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _price2Controller = TextEditingController();
  final bufferCtl = Get.find<BufferController>();

  Future<void> createBuffer() async {
    if (_formKey.currentState!.validate()) {
      Buffer buffer = Buffer(
          bufferId: widget.buffer.bufferId,
          bufferType: _itemNameController.text,
          pricePerPerson: int.parse(_priceController.text),
          pricePerPerson2: int.parse(_price2Controller.text));
      try {
        await bufferCtl.updateBuffer(buffer);
        Get.back();
        CherryToast.success(
          title: const Text("Cập nhật Buffer thành công"),
        ).show(context);
        setState(() {
          _itemNameController.text = '';
          _priceController.text = '';
        });
      } catch (e) {
        Get.back();
        CherryToast.error(
          title: const Text("Cập nhật Buffer thất baij"),
        ).show(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _itemNameController.text = widget.buffer.bufferType!;
    _priceController.text = widget.buffer.pricePerPerson.toString();
    _price2Controller.text = widget.buffer.pricePerPerson2.toString();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật Buffer',
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
                  "Tên Buffer",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên buffer',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.food_bank_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng tên ';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Giá người lớn",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: 'Nhập giá',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person_2_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng giá';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Giá phải là số';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Giá trẻ em",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _price2Controller,
                  decoration: InputDecoration(
                    hintText: 'Nhập giá',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person_2_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng giá';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Giá phải là số';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      createBuffer();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text('Cập nhật Buffer',
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

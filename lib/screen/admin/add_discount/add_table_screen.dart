import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/discount.dart';
import 'package:qlnh/screen/admin/discount/controller/discount_controller.dart';
import 'package:qlnh/services/api.dart';

class AddDiscountScreen extends StatefulWidget {
  @override
  _AddDiscountScreenState createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends State<AddDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();

  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final discountCtl = Get.find<DiscountController>();

  Future<void> createBuffer() async {
    if (_formKey.currentState!.validate()) {
      Discount discount = Discount(
          title: _itemNameController.text,
          code: _itemCodeController.text,
          price: int.parse(_priceController.text));
      try {
        await ApiService().addDiscount(discount);
        discountCtl.getListDiscount();
        CherryToast.success(
          title: const Text("Thêm Mã giảm giá thành công"),
        ).show(context);
        setState(() {
          _itemNameController.text = '';
          _priceController.text = '';
        });
      } catch (e) {
        CherryToast.error(
          title: const Text("Thêm Mã giảm giá thất baij"),
        ).show(context);
      }
    }
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
        title: const Text('Thêm Mã giảm giá',
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
                  "Tên Mã",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên mã',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.title_outlined),
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
                  "Mã",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _itemCodeController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mã',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.code),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng mã ';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Số tiền giảm",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: 'Nhập số tiền giảm',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person_2_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tiền giảm';
                    }
                    if (int.tryParse(value) == null) {
                      return 'số tiền phải là số';
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
                    child: Text('Thêm Mã',
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

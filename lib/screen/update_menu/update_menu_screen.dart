import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/controller/menu_controller.dart';
import 'package:qlnh/services/api.dart';

class UpdateMenuScreen extends StatefulWidget {
  final Menu? menuToEdit; // Thêm tham số menuToEdit

  const UpdateMenuScreen({Key? key, this.menuToEdit}) : super(key: key);

  @override
  _UpdateMenuScreenState createState() => _UpdateMenuScreenState();
}

class _UpdateMenuScreenState extends State<UpdateMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _selectedImage;
  final menuCtl = Get.find<MenusController>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Nếu có menu để chỉnh sửa, điền thông tin vào các trường
    if (widget.menuToEdit != null) {
      _itemNameController.text = widget.menuToEdit!.itemName!;
      _priceController.text = widget.menuToEdit!.price.toString();
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // Chọn ảnh từ thư viện
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Phương thức cập nhật
  Future<void> updateMenu() async {
    if (_formKey.currentState!.validate()) {
      Menu menu = Menu(
        menuId: widget
            .menuToEdit?.menuId, // Đảm bảo có ID của thực đơn cần cập nhật
        itemName: _itemNameController.text,
        price: int.parse(_priceController.text),
      );
      try {
        await ApiService()
            .updateMenuWithImage(menu, _selectedImage)
            .whenComplete(
          () {
            menuCtl.getListMenu();
            setState(() {
              _itemNameController.text = '';
              _priceController.text = '';
              _selectedImage = null;
            });
            Get.back();
            CherryToast.success(
              title: Text("Cập nhật thực đơn thành công"),
            ).show(context);
          },
        );
      } catch (e) {
        CherryToast.success(
          title: Text("Cập nhật thực đơn thất bại"),
        ).show(context);
      }
    } else {
      CherryToast.warning(
        title: Text("Không được thiếu trường nào"),
      ).show(context);
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
        title: Text(
            widget.menuToEdit == null ? 'Thêm thực đơn' : 'Cập nhật thực đơn',
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
                Text("Sửa thực đơn",
                    style: GlobalTextStyles.font14w600ColorBlack),
                const Gap(4),
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên thực đơn',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.fastfood),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên thực đơn';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text("Giá tiền", style: GlobalTextStyles.font14w600ColorBlack),
                const Gap(4),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: 'Nhập giá tiền',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập giá';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Giá bắt buộc là số';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text("Ảnh thực đơn",
                    style: GlobalTextStyles.font14w600ColorBlack),
                const Gap(4),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : widget.menuToEdit?.image != null &&
                                widget.menuToEdit!.image!.isNotEmpty
                            ? Image.network(widget.menuToEdit!.image!,
                                fit: BoxFit.cover)
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Click để chọn ảnh',
                                      style: TextStyle(color: Colors.grey)),
                                  Gap(8.0),
                                  Icon(Icons.image, color: Colors.grey)
                                ],
                              ),
                  ),
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: updateMenu,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                        widget.menuToEdit == null
                            ? 'Thêm thực đơn'
                            : 'Cập nhật thực đơn',
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

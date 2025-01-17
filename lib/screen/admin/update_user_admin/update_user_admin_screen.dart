import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/user.dart';
import 'package:qlnh/screen/admin/personnel/controller/personnel_controller.dart';

class UpdateUserAdminScreen extends StatefulWidget {
  const UpdateUserAdminScreen({super.key, required this.user});
  final User user;
  @override
  _UpdateUserAdminScreenState createState() => _UpdateUserAdminScreenState();
}

class _UpdateUserAdminScreenState extends State<UpdateUserAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final userCtl = Get.find<UserController>();

  Future<void> createuser() async {
    if (_formKey.currentState!.validate()) {
      User user = widget.user.copyWith(
          email: _emailController.text, userName: _nameController.text);
      try {
        await userCtl.updateUser(user);
        Get.back();
        CherryToast.success(
          title: const Text("Cập nhật thông tin thành công"),
        ).show(context);
        setState(() {
          _nameController.text = '';
          _emailController.text = '';
        });
      } catch (e) {
        Get.back();
        CherryToast.error(
          title: const Text("Cập nhật thông tin thất baij"),
        ).show(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.fullName!;
    _emailController.text = widget.user.email!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật user',
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
                  "Tên user",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên user',
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
                  "Email",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Nhập email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person_2_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      createuser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text('Cập nhật user',
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

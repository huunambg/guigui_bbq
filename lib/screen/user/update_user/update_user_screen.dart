import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/user.dart';
import 'package:qlnh/screen/admin/personnel/controller/personnel_controller.dart';
import 'package:qlnh/screen/user/login/controller/login_controller.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key, required this.user});
  final User user;
  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final userCtl = Get.find<UserController>();

  Future<void> updateUser() async {
    if (_formKey.currentState!.validate()) {
      User user = widget.user.copyWith(
          password: _passwordController.text.isNotEmpty
              ? _passwordController.text
              : widget.user.password,
          userName: _nameController.text);
      try {
        await userCtl.updateUser(user);
        Get.back();
        Get.find<LoginController>().userData.value = user;
        CherryToast.success(
          title: const Text("Cập nhật user thành công"),
        ).show(context);
        setState(() {
          _nameController.text = '';
          _passwordController.text = '';
        });
      } catch (e) {
        Get.back();
        Get.find<LoginController>().userData.value = user;
        CherryToast.success(
          title: const Text("Cập nhật user thành công"),
        ).show(context);
        setState(() {
          _nameController.text = '';
          _passwordController.text = '';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.fullName!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
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
                      return 'Vui lòng nhập tên';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Mật khẩu",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
                const Gap(4),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      updateUser();
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

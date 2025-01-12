import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isRePasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền trắng
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 108.0,
                  height: 108.0,
                  fit: BoxFit.contain,
                ),
              ),
              Center(
                child: Text(
                  "Đăng Ký",
                  style: GlobalTextStyles.font24w700ColorBlack,
                ),
              ),

              const Gap(20),
              // Email TextField
              Text(
                "Email",
                style: GlobalTextStyles.font14w500Colorblack,
              ),
              const Gap(4),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: _emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12),
                    isDense: true,
                    fillColor: GlobalColors.container,
                    hintText: 'Nhập email',
                    hintStyle: GlobalTextStyles.font16w400ColorBlackOp50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.4))),
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Mật khẩu",
                style: GlobalTextStyles.font14w500Colorblack,
              ),
              const Gap(4),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, // Ẩn hoặc hiện mật khẩu
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12),
                    isDense: true,
                    fillColor: GlobalColors.container,
                    hintText: 'Nhập mật khẩu',
                    hintStyle: GlobalTextStyles.font16w400ColorBlackOp50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.4))),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "Nhập lại mật khẩu",
                style: GlobalTextStyles.font14w500Colorblack,
              ),
              const Gap(4),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: _rePasswordController,
                  obscureText: !_isRePasswordVisible, // Ẩn hoặc hiện mật khẩu
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12),
                    isDense: true,
                    fillColor: GlobalColors.container,
                    hintText: 'Nhập lại mật khẩu',
                    hintStyle: GlobalTextStyles.font16w400ColorBlackOp50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.4))),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isRePasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFF61677D),
                      ),
                      onPressed: () {
                        setState(() {
                          _isRePasswordVisible = !_isRePasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlobalColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text('Đăng Ký',
                      style: GlobalTextStyles.font16w600ColorWhite
                          .copyWith(color: Colors.white.withOpacity(.9))),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bạn đã có tài khoản?",
                    style: GlobalTextStyles.font12w400ColorBlack
                        .copyWith(color: Colors.black.withOpacity(.6)),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Đăng nhập',
                      style: GlobalTextStyles.font12w400ColorBlack
                          .copyWith(color: GlobalColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

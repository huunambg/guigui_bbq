import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/screen/together/register/register_screen.dart';
import '/config/api_state.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import 'controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final loginCtl = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => loginCtl.apiState.value == ApiState.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
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
                          "Đăng Nhập",
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _emailController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 12),
                            isDense: true,
                            hintText: 'Nhập email',
                            hintStyle:
                                GlobalTextStyles.font16w400ColorBlackOp50,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.4))),
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.black.withOpacity(.5),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),

                      const Gap(20),

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
                          obscureText:
                              !_isPasswordVisible, // Ẩn hoặc hiện mật khẩu
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 12),
                            isDense: true,
                            hintText: 'Nhập mật khẩu',
                            hintStyle:
                                GlobalTextStyles.font16w400ColorBlackOp50,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.4))),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black.withOpacity(.5),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black.withOpacity(.5),
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

                      const SizedBox(height: 30),

                      // Login Button

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            loginCtl.login(_emailController.text,
                                _passwordController.text, context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GlobalColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Đăng nhập',
                            style: GlobalTextStyles.font16w600ColorWhite
                                .copyWith(color: Colors.white.withOpacity(.9)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bạn chưa có tài khoản?",
                            style: GlobalTextStyles.font12w400ColorBlack
                                .copyWith(color: Colors.black.withOpacity(.6)),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() => const RegisterScreen());
                            },
                            child: Text(
                              'Đăng ký',
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
      ),
    );
  }
}

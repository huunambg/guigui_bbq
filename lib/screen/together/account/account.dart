import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/screen/together/splash/splash.dart';
import 'package:qlnh/screen/user/login/controller/login_controller.dart';
import 'package:qlnh/services/api.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:qlnh/util/preferences_util.dart';

class AcountScreen extends StatefulWidget {
  const AcountScreen({super.key});

  @override
  State<AcountScreen> createState() => _AcountScreenState();
}

class _AcountScreenState extends State<AcountScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final loginCtl = Get.find<LoginController>();
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _showConfirmationDialog();
    }
  }

  Future<void> _uploadAvatar() async {
    if (_selectedImage == null) return;
    try {
      String? urlImage = await ApiService()
          .uploadAvatar(_selectedImage, loginCtl.userData.value.userId!);
      if (urlImage != null) {
        loginCtl.userData.value.image = urlImage;
        CherryToast.success(
          title: const Text("Cập nhật ảnh đại điện thành công"),
        ).show(context);
      }
    } catch (e) {}
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Upload"),
          content: _selectedImage != null
              ? Image.file(
                  _selectedImage!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : const Text("No image selected."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _uploadAvatar(); // Proceed with upload
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: [
          const Gap(30.0),
          Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: w * 0.3,
                          height: w * 0.3,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: w * 0.3,
                          height: w * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(.2),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Obx(
                            () => loginCtl.userData.value.image != null &&
                                    loginCtl.userData.value.image != "null"
                                ? Image.network(
                                    loginCtl.userData.value.image!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  )
                                : Image.asset(
                                    "assets/images/avatar.png",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 16,
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16.0),
          Center(
            child: Text(
              loginCtl.userData.value.fullName!,
              style: GlobalTextStyles.font18w700ColorBlack,
            ),
          ),
          const Gap(8.0),
          Center(
            child: Obx(
              () => Text(
                loginCtl.userData.value.role == 'Admin'
                    ? "Quản lý nhà hàng"
                    : "Nhân viên chính thức",
                style: GlobalTextStyles.font14w500Colorblack,
              ),
            ),
          ),
          const Gap(16.0),
          ItemAccount_OK(
              icon: Icons.person_2_outlined,
              onpressed: () {},
              titile: "Sửa thông tin"),
          ItemAccount_OK(
              icon: CupertinoIcons.bell, onpressed: () {}, titile: "Thông báo"),
          ItemAccount_OK(
              icon: Icons.help_center_outlined,
              onpressed: () {},
              titile: "Hướng dẫn"),
          ItemAccount_OK(
              icon: Icons.lock_outline,
              onpressed: () {
                PanaraConfirmDialog.show(
                  context,
                  title: "Xin chào",
                  message: "Bạn có muốn đăng xuất tài khoản!",
                  confirmButtonText: "Đăng xuất",
                  cancelButtonText: "Quay lại",
                  onTapCancel: () {
                    Get.back();
                  },
                  onTapConfirm: () {
                    Get.back();
                    Future.delayed(
                      1.seconds,
                      () {
                        PreferencesUtil.clearEmail();
                        PreferencesUtil.clearPassword();
                        Get.offAll(const SplashScreen());
                      },
                    );
                  },
                  panaraDialogType: PanaraDialogType.warning,
                  barrierDismissible: false,
                );
              },
              titile: "Đăng xuất"),
        ],
      ),
    );
  }
}

class ItemAccount_OK extends StatelessWidget {
  const ItemAccount_OK(
      {super.key,
      required this.icon,
      required this.onpressed,
      required this.titile});
  final icon;
  final GestureTapCallback onpressed;
  final String titile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black12,
        child: ListTile(
          onTap: onpressed,
          leading: Icon(icon),
          title: Text(titile),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

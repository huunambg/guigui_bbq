import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/screen/admin/buffer_admin/buffer_screen.dart';
import 'package:qlnh/screen/admin/statistical/statistical.dart';
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
          title: const Text("Cập nhật ảnh đại diện thành công"),
        ).show(context);
      }
    } catch (e) {
      CherryToast.error(
        title: const Text("Có lỗi xảy ra khi tải ảnh lên"),
      ).show(context);
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Xác nhận tải lên"),
          content: _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              : const Text("Chưa chọn ảnh nào."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadAvatar();
              },
              child: const Text("Tải lên"),
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
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: [
          const Gap(30.0),
          Center(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            width: w * 0.34,
                            height: w * 0.34,
                            fit: BoxFit.cover,
                          )
                        : Obx(
                            () => loginCtl.userData.value.image != null &&
                                    loginCtl.userData.value.image != "null"
                                ? Image.network(
                                    loginCtl.userData.value.image!,
                                    width: w * 0.34,
                                    height: w * 0.34,
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
                                    width: w * 0.3,
                                    height: w * 0.3,
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
                        size: 18,
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
              style: GlobalTextStyles.font18w700ColorBlack.copyWith(
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ),
          const Gap(8.0),
          Center(
            child: Obx(
              () => Text(
                loginCtl.userData.value.role == 'Admin'
                    ? "Quản lý nhà hàng"
                    : "Nhân viên chính thức",
                style: GlobalTextStyles.font14w500Colorblack.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          const Gap(16.0),
          const Divider(),
          const Gap(16.0),
          ItemAccount_OK(
            iconColor: GlobalColors.primary,
            icon: Icons.person_2_outlined,
            onpressed: () {},
            titile: "Sửa thông tin",
          ),
          loginCtl.userData.value.role == 'Admin'
              ? ItemAccount_OK(
                  iconColor: GlobalColors.primary,
                  icon: Icons.food_bank_outlined,
                  onpressed: () {
                    Get.to(() => const BufferAdminScreen());
                  },
                  titile: "Quản lý Buffer",
                )
              : const SizedBox(),
          ItemAccount_OK(
            iconColor: GlobalColors.primary,
            icon: Icons.help_center_outlined,
            onpressed: () {Get.to(TransactionStatisticsScreen());},
            titile: "Thống kê",
          ),
          ItemAccount_OK(
            iconColor: GlobalColors.primary,
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
            titile: "Đăng xuất",
          ),
        ],
      ),
    );
  }
}

class ItemAccount_OK extends StatelessWidget {
  const ItemAccount_OK({
    super.key,
    required this.icon,
    required this.onpressed,
    required this.titile,
    this.cardColor = Colors.white,
    this.iconColor = Colors.blue,
    this.textColor = Colors.black87,
    this.trailingColor = Colors.grey,
  });

  final IconData icon;
  final GestureTapCallback onpressed;
  final String titile;
  final Color cardColor;
  final Color iconColor;
  final Color textColor;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: cardColor,
        elevation: 6,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: onpressed,
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text(
            titile,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: trailingColor,
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:qlnh/services/api.dart';

class AcountScreen extends StatefulWidget {
  const AcountScreen({super.key});

  @override
  State<AcountScreen> createState() => _AcountScreenState();
}

class _AcountScreenState extends State<AcountScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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

    ApiService().uploadAvatar(_selectedImage, 1);
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
        padding: const EdgeInsets.all(16),
        children: [
          const Gap(30.0),
          Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: w * 0.24,
                          height: w * 0.24,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: w * 0.24,
                          height: w * 0.24,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            "assets/images/avatar.png",
                            fit: BoxFit.cover,
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
          ItemAccount_OK(
              icon: Icons.location_on_outlined,
              onpressed: () {},
              titile: "Sửa thông tin"),
          ItemAccount_OK(
              icon: CupertinoIcons.bell, onpressed: () {}, titile: "Thông báo"),
          ItemAccount_OK(
              icon: Icons.help_center_outlined,
              onpressed: () {},
              titile: "Hướng dẫn"),
          ItemAccount_OK(
              icon: Icons.lock_outline, onpressed: () {}, titile: "Đăng xuất"),
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

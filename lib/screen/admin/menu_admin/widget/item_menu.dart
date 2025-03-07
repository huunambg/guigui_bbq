import 'package:flutter/material.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/model/menu.dart';
import 'package:qlnh/util/convert.dart';

class ItemMenuCustom extends StatelessWidget {
  const ItemMenuCustom({super.key, required this.menu});
  final Menu menu;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Hình ảnh với khung cải tiến
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200, // Nền dự phòng
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: GlobalColors.primary.withOpacity(.6), // Màu viền
                  width: 2.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: menu.image != null && menu.image != "null"
                    ? Image.network(
                        menu.image!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.error_outline,
                          color: Colors.redAccent.shade200,
                          size: 36,
                        ),
                      )
                    : Icon(
                        Icons.fastfood_outlined,
                        color: Colors.grey.shade400,
                        size: 36,
                      ),
              ),
            ),
            const SizedBox(width: 16.0),
            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.itemName ?? "Chưa có tên",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    tienviet(menu.price ?? 0),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // // Nút thêm vào giỏ hàng
            // InkWell(
            //   onTap: () {
            //     // Hành động khi nhấn
            //   },
            //   borderRadius: BorderRadius.circular(24),
            //   child: Container(
            //     padding: const EdgeInsets.all(8.0),
            //     decoration: BoxDecoration(
            //       gradient:  LinearGradient(
            //         colors: [Colors.greenAccent, GlobalColors.primary],
            //       ),
            //       shape: BoxShape.circle,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.orangeAccent.withOpacity(0.4),
            //           blurRadius: 8,
            //           offset: const Offset(0, 4),
            //         ),
            //       ],
            //     ),
            //     child: const Icon(
            //       Icons.check,
            //       color: Colors.white,
            //       size: 24.0,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qlnh/model/discount.dart';
import 'package:qlnh/util/convert.dart';

class ItemDiscount extends StatelessWidget {
  const ItemDiscount({super.key, required this.discount});
  final Discount discount;

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
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                height: 60,
                width: 60,
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
                ),
                child: Icon(Icons.discount),
              ),
            ),
            const SizedBox(width: 16.0),
            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tên: ${discount.title}" ,
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
                    "Code: ${discount.code}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Giảm: ${tienviet(discount.price ?? 0)}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Nút thêm vào giỏ hàng
            // InkWell(
            //   onTap: () {
            //     // Hành động khi nhấn
            //   },
            //   borderRadius: BorderRadius.circular(24),
            //   child: Container(
            //     padding: const EdgeInsets.all(8.0),
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
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

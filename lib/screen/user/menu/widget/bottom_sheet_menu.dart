import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/menu.dart';

class BottomSheetMenu extends StatefulWidget {
  const BottomSheetMenu({super.key, required this.menu, required this.onAdd});
  final Menu menu;
  final ValueChanged<int> onAdd;
  @override
  State<BottomSheetMenu> createState() => _BottomSheetMenuState();
}

class _BottomSheetMenuState extends State<BottomSheetMenu> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      height: h * 0.4,
      width: w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close,
                  size: 26.0,
                )),
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const Gap(16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.menu.itemName!,
                      style: GlobalTextStyles.font18w700ColorBlack,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${(widget.menu.price! / 1000).toInt()}K",
                      style: GlobalTextStyles.font16w600ColorBlack,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
                  }
                },
                child: SvgPicture.asset(
                  "assets/icons/ic_minus.svg",
                  width: 36.0,
                  height: 36.0,
                ),
              ),
              const Gap(16.0),
              Text(
                "$quantity",
                style: GlobalTextStyles.font18w700ColorBlack,
              ),
              const Gap(16.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    quantity++;
                  });
                },
                child: SvgPicture.asset(
                  "assets/icons/ic_plus.svg",
                  width: 36.0,
                  height: 36.0,
                ),
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onAdd(quantity);
                Get.back();
                CherryToast.success(
                        description: const Text("Thêm thành công",
                            style: TextStyle(color: Colors.black)),
                        animationDuration: const Duration(milliseconds: 1000),
                        autoDismiss: true)
                    .show(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text('Thêm sản phẩm',
                  style: GlobalTextStyles.font16w600ColorWhite
                      .copyWith(color: Colors.white.withOpacity(.9))),
            ),
          ),
        ],
      ),
    );
  }
}

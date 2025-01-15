import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qlnh/config/global_color.dart';
import 'package:qlnh/config/global_text_style.dart';
import 'package:qlnh/model/menu.dart';

class BottomSheetUpdateMenu extends StatefulWidget {
  const BottomSheetUpdateMenu(
      {super.key,
      required this.menu,
      required this.onAdd,
      required this.quantity});
  final Menu menu;
  final ValueChanged<int> onAdd;
  final int quantity;
  @override
  State<BottomSheetUpdateMenu> createState() => _BottomSheetUpdateMenuState();
}

class _BottomSheetUpdateMenuState extends State<BottomSheetUpdateMenu> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

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
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: widget.menu.image != null &&
                          widget.menu.image != "null"
                      ? Image.network(
                          widget.menu.image!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.error,
                            color: Colors.grey,
                            size: 30,
                          ),
                        )
                      : Image.network(
                          "Null",
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.error,
                            color: Colors.grey,
                            size: 30,
                          ),
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
                  if (quantity > 0) {
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
                        description: const Text("Cập nhật thành công",
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

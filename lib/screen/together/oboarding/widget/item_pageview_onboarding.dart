import '/config/global_text_style.dart';
import 'package:flutter/material.dart';

class ItemPageviewOnboarding extends StatefulWidget {
  const ItemPageviewOnboarding(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.description});
  final String imagePath;
  final String title;
  final String description;

  @override
  State<ItemPageviewOnboarding> createState() => _ItemPageviewOnboardingState();
}

class _ItemPageviewOnboardingState extends State<ItemPageviewOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.imagePath,
            width: 180.0,
            height: 180.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            widget.title,
            style: GlobalTextStyles.font18w700ColorBlack,
          ),
          const SizedBox(height: 12),
          Text(
            textAlign: TextAlign.center,
            widget.description,
            style: GlobalTextStyles.font15w600Color3C3C43,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BodyCustom extends StatelessWidget {
  const BodyCustom(
      {super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: child);
  }
}

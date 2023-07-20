import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  void Function()? onTap;
  Widget? child;
  bool rounded;
  CustomInkWell(this.onTap, this.child, {this.rounded = true, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: rounded ? BorderRadius.circular(10) : null,
      child: Material(
          child: InkWell(
        onTap: onTap,
        child: child,
      )),
    );
  }
}

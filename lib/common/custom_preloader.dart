import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../helpers/constant_colors.dart';

class CustomPreloader extends StatelessWidget {
  final bool? whiteColor;
  double? width;
  CustomPreloader({
    super.key,
    this.whiteColor = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.bottomCenter,
      child: LoadingAnimationWidget.prograssiveDots(
        color: whiteColor! ? cc.pureWhite : cc.primaryColor,
        size: 70,
      ),
    );
  }
}

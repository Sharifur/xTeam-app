import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

class FieldTitle extends StatelessWidget {
  String title;
  FieldTitle(this.title, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: cc.greyHint,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

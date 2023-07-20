import 'package:flutter/material.dart';

import '../helpers/constant_colors.dart';

class CustomDropdown extends StatelessWidget {
  String hintText;
  List listData;
  String? value;
  void Function(dynamic)? onChanged;
  CustomDropdown(this.hintText, this.listData, this.onChanged,
      {this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: cc.greyBorder,
          width: 1,
        ),
      ),
      child: DropdownButton(
        hint: Text(
          hintText,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: cc.greyHint,
                fontSize: 14,
              ),
        ),
        underline: Container(),
        isExpanded: true,
        elevation: 0,
        isDense: true,
        value: value,
        style: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: cc.greyHint,
              fontSize: 14,
            ),
        icon: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: cc.greyHint,
        ),
        onChanged: onChanged,
        items: (listData).map((value) {
          return DropdownMenuItem(
            alignment: Alignment.centerLeft,
            value: value,
            child: SizedBox(
              // width: screenWidth - 140,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

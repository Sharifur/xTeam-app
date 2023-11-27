import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/constant_colors.dart';

class DefaultThemes {
  InputDecorationTheme? inputDecorationTheme(BuildContext context) =>
      InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: cc.greyHint,
              fontSize: 14,
            ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 17),
        focusedBorder: OutlineInputBorder(
          // borderRadius: const BorderRadius.only(
          //     bottomLeft: Radius.circular(12), topRight: Radius.circular(12)),
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: ConstantColors().primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          // borderRadius: const BorderRadius.only(
          //     bottomLeft: Radius.circular(12), topRight: Radius.circular(12)),
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ConstantColors().greyBorder, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // borderRadius: const BorderRadius.only(
          //     bottomLeft: Radius.circular(12), topRight: Radius.circular(12)),
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ConstantColors().red, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          // borderRadius: const BorderRadius.only(
          //     bottomLeft: Radius.circular(12), topRight: Radius.circular(12)),
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ConstantColors().red, width: 1),
        ),
      );

  CheckboxThemeData? checkboxTheme(BuildContext context) => CheckboxThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          width: 1,
          color: ConstantColors().secondaryColor,
        ),
        // activeColor: cc.primaryColor,
        fillColor: MaterialStateColor.resolveWith(
            (states) => ConstantColors().secondaryColor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              width: 1,
              color: ConstantColors().secondaryColor,
            )),
      );
  RadioThemeData? radioThemeData(BuildContext context) => RadioThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // side: BorderSide(
        //   width: 1,
        //   color: ConstantColors().secondaryColor,
        // ),
        // activeColor: cc.primaryColor,
        fillColor: MaterialStateColor.resolveWith(
            (states) => ConstantColors().secondaryColor),
        visualDensity: VisualDensity.compact,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(6),
        //     side: BorderSide(
        //       width: 1,
        //       color: ConstantColors().secondaryColor,
        //     )),
      );

  OutlinedButtonThemeData? outlinedButtonTheme(BuildContext context) =>
      OutlinedButtonThemeData(
          style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((states) {
          // Rounded button (when the button is pressed)
          // if (states.contains(MaterialState.pressed)) {
          //   return RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10),);
          // }
          return RoundedRectangleBorder(
              // borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(12),
              //     topRight: Radius.circular(12))
              borderRadius: BorderRadius.circular(8));
          // }
        }),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return BorderSide(
              color: ConstantColors().primaryColor,
            );
          }
          return BorderSide(
            color: ConstantColors().greyBorder,
          );
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return ConstantColors().primaryColor;
          }
          return ConstantColors().greyHint;
        }),
      ));

  ElevatedButtonThemeData? elevatedButtonTheme(BuildContext context) =>
      ElevatedButtonThemeData(
          style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 0),
        overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((states) {
          // Rounded button (when the button is pressed)
          // if (states.contains(MaterialState.pressed)) {
          //   return RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10),);
          // }
          return RoundedRectangleBorder(
              // borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(12),
              //     topRight: Radius.circular(12))
              borderRadius: BorderRadius.circular(8));
          // }
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return ConstantColors().blackColor;
          }
          return ConstantColors().primaryColor;
        }),
        // padding:
        //     MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15)),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return ConstantColors().pureWhite;
          }
          return ConstantColors().pureWhite;
        }),
      ));

  appBarTheme(BuildContext context) => AppBarTheme(
        backgroundColor: cc.pureWhite,
        foregroundColor: cc.blackColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        surfaceTintColor: cc.pureWhite,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
      );

  SwitchThemeData switchThemeData() => SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return cc.primaryColor.withOpacity(.10);
          }
          return cc.pureWhite;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (!states.contains(MaterialState.selected)) {
            return cc.black8;
          }
          return cc.primaryColor.withOpacity(.60);
        }),
        trackOutlineColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (!states.contains(MaterialState.selected)) {
            return cc.black8;
          }
          return cc.primaryColor.withOpacity(.40);
        }),
      );
}

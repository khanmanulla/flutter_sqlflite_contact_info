import 'package:flutter/material.dart';
import 'package:user_info/common/styles/color_palate.dart';
import 'package:user_info/common/styles/font_size.dart';

class FormStyles {
  static const defaultRadius = 8.0;

  static black32TextStyles() {
    return TextStyle(color: ColorPalate.blackPearl, fontSize: FontSize.huge, fontWeight: FontWeight.w500);
  }

  static black24TextStyles() {
    return TextStyle(color: ColorPalate.blackPearl, fontSize: FontSize.extraLarge, fontWeight: FontWeight.w500);
  }

  static black20TextStyles() {
    return TextStyle(color: ColorPalate.blackPearl, fontSize: FontSize.large, fontWeight: FontWeight.w500);
  }

  static white20TextStyle() {
    return TextStyle(color: ColorPalate.white, fontSize: FontSize.large, fontWeight: FontWeight.w500);
  }

  static black16TextStyles() {
    return TextStyle(fontSize: FontSize.medium, color: ColorPalate.blackPearl, fontWeight: FontWeight.w500);
  }

  static lightBlack14TextStyle() {
    return TextStyle(color: ColorPalate.lightBlack, fontSize: FontSize.regular);
  }

  static grey14TextStyle() {
    return TextStyle(color: ColorPalate.grey, fontSize: FontSize.regular);
  }

  static blue14TextStyle() {
    return TextStyle(color: ColorPalate.blue, fontSize: FontSize.regular);
  }
}

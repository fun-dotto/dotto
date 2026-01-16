import 'package:dotto_design_system/style/primitive_color.dart';
import 'package:flutter/material.dart';

enum BusType {
  kameda('亀田支所', PrimitiveColor.gray500),
  goryokaku('五稜郭方面', PrimitiveColor.red500),
  syowa('昭和方面', PrimitiveColor.blue500),
  other('', PrimitiveColor.gray500);

  const BusType(this.where, this.dividerColor);

  final String where;
  final Color dividerColor;
}

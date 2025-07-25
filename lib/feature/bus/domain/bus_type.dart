import 'package:dotto/importer.dart';
import 'package:dotto/theme/v1/app_color.dart';

enum BusType {
  kameda('亀田支所', Colors.grey),
  goryokaku('五稜郭方面', AppColor.dividerRed),
  syowa('昭和方面', AppColor.linkTextBlue),
  other('', Colors.grey);

  const BusType(this.where, this.dividerColor);

  final String where;
  final Color dividerColor;
}

import 'package:dotto/asset.dart';
import 'package:flutter/material.dart';

final class SettingsLicenseScreen extends StatelessWidget {
  const SettingsLicenseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return LicensePage(applicationName: 'Dotto', applicationIcon: Image.asset(Asset.icon768, width: 150));
  }
}

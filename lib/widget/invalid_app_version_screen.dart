import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class InvalidAppVersionScreen extends StatelessWidget {
  const InvalidAppVersionScreen({required this.appStorePageUrl, super.key});

  final String appStorePageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dottoのアップデートが必要です'),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 64,
          children: [
            const Text('最新版のDottoをご利用ください'),
            DottoButton(
              onPressed: () => launchUrlString(
                appStorePageUrl,
                mode: LaunchMode.externalApplication,
              ),
              child: const Text('今すぐアップデート'),
            ),
          ],
        ),
      ),
    );
  }
}

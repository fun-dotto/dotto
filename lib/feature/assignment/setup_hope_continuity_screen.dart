import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/feature/assignment/controller/hope_user_key_controller.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SetupHopeContinuityScreen extends ConsumerWidget {
  SetupHopeContinuityScreen({super.key, this.onUserKeySaved});

  final controller = TextEditingController();

  final void Function()? onUserKeySaved;

  Future<void> _launchUrlInAppBrowserView(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configNotifierProvider);
    final hopeUserKey = ref.watch(hopeUserKeyNotifierProvider);
    final hopeUserKeyNotifier = ref.read(hopeUserKeyNotifierProvider.notifier);

    controller.text = hopeUserKey.value ?? '';

    return hopeUserKey.when(
      data: (userKey) => Column(
        spacing: 8,
        children: [
          DottoButton(
            onPressed: () {
              final formUrl = config.userKeySettingUrl;
              final url = Uri.parse(formUrl);
              _launchUrlInAppBrowserView(url);
            },
            type: DottoButtonType.text,
            child: const Text('HOPEと連携する'),
          ),
          const Divider(),
          TextField(
            controller: controller,
            // 入力数
            maxLength: 16,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'ユーザーキー',
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(16),
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DottoButton(
              onPressed: controller.text.length == 16
                  ? () async {
                      await hopeUserKeyNotifier.set(controller.text);
                      onUserKeySaved?.call();
                    }
                  : null,
              child: const Text('保存'),
            ),
          ),
        ],
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}

import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/feature/assignment/controller/hope_continuity_text_editing_controller.dart';
import 'package:dotto/feature/assignment/controller/hope_user_key_controller.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SetupHopeContinuityScreen extends ConsumerWidget {
  const SetupHopeContinuityScreen({super.key, this.onUserKeySaved});

  final void Function()? onUserKeySaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configNotifierProvider);
    final hopeUserKey = ref.watch(hopeUserKeyNotifierProvider);
    final hopeUserKeyNotifier = ref.read(hopeUserKeyNotifierProvider.notifier);
    final textEditingController = ref.watch(
      hopeContinuityTextEditingControllerProvider,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: hopeUserKey.when(
        data: (userKey) => Column(
          spacing: 8,
          children: [
            DottoButton(
              onPressed: () {
                launchUrlString(config.assignmentSetupUrl);
              },
              type: DottoButtonType.text,
              child: const Text('HOPEと連携する'),
            ),
            TextField(
              controller: textEditingController,
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
                onPressed:
                    textEditingController.text.isEmpty ||
                        textEditingController.text.length == 16
                    ? () async {
                        await hopeUserKeyNotifier.set(
                          textEditingController.text,
                        );
                        onUserKeySaved?.call();
                      }
                    : null,
                child: const Text('保存'),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => const Center(child: Text('エラーが発生しました')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

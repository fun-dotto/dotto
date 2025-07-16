import 'dart:io';

import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/announcement/announcement_screen.dart';
import 'package:dotto/feature/setting/controller/settings_controller.dart';
import 'package:dotto/feature/setting/repository/settings_repository.dart';
import 'package:dotto/feature/setting/widget/license.dart';
import 'package:dotto/feature/setting/widget/settings_set_userkey.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/widget/app_tutorial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

final class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> launchUrlInAppBrowserView(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Widget listDialog(BuildContext context, String title,
      UserPreferenceKeys userPreferenceKeys, List<String> list) {
    return AlertDialog(
      title: Text(title),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              const Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(list[index]),
                        onTap: () async {
                          await UserPreferenceRepository.setString(
                              userPreferenceKeys, list[index]);
                          if (context.mounted) {
                            Navigator.pop(context, list[index]);
                          }
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.read(userProvider.notifier);
    final user = ref.watch(userProvider);
    final config = ref.watch(configControllerProvider);

    // 設定を取得
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: Colors.white,
          settingsSectionBackground:
              (Platform.isIOS) ? const Color(0xFFF7F7F7) : null,
        ),
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              // Googleでログイン
              SettingsTile.navigation(
                title: Text(
                  (user == null) ? 'ログイン' : 'ログイン中',
                ),
                value: (Platform.isIOS)
                    ? (user == null)
                        ? null
                        : const Text('ログアウト')
                    : Text((user == null)
                        ? '未来大Googleアカウント'
                        : '${user.email}でログイン中'),
                description: (Platform.isIOS)
                    ? Text((user == null)
                        ? '未来大Googleアカウント'
                        : '${user.email}でログイン中')
                    : null,
                leading: Icon((user == null) ? Icons.login : Icons.logout),
                onPressed: (user == null)
                    ? (c) => SettingsRepository().onLogin(
                        c, (User? user) => userNotifier.user = user, ref)
                    : (_) => SettingsRepository().onLogout(userNotifier.logout),
              ),
              // 学年
              SettingsTile.navigation(
                onPressed: (context) async {
                  final returnText = await showDialog<String>(
                      context: context,
                      builder: (_) {
                        return listDialog(
                            context,
                            '学年',
                            UserPreferenceKeys.grade,
                            ['なし', '1年', '2年', '3年', '4年']);
                      });
                  if (returnText != null) {
                    ref.invalidate(settingsGradeProvider);
                  }
                },
                leading: const Icon(Icons.school),
                title: const Text('学年'),
                value:
                    Text(ref.watch(settingsGradeProvider).valueOrNull ?? 'なし'),
              ),
              // コース
              SettingsTile.navigation(
                onPressed: (context) async {
                  final returnText = await showDialog<String>(
                      context: context,
                      builder: (_) {
                        return listDialog(
                            context,
                            'コース',
                            UserPreferenceKeys.course,
                            ['なし', '情報システム', '情報デザイン', '知能', '複雑', '高度ICT']);
                      });
                  if (returnText != null) {
                    ref.invalidate(settingsCourseProvider);
                  }
                },
                leading: const Icon(Icons.school),
                title: const Text('コース'),
                value:
                    Text(ref.watch(settingsCourseProvider).valueOrNull ?? 'なし'),
              ),
              // ユーザーキー
              SettingsTile.navigation(
                title: const Text('課題のユーザーキー'),
                value:
                    Text(ref.watch(settingsUserKeyProvider).valueOrNull ?? ''),
                leading: const Icon(Icons.assignment),
                onPressed: (context) {
                  Navigator.of(context).push(PageRouteBuilder<void>(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SettingsSetUserkeyScreen(),
                    transitionsBuilder: fromRightAnimation,
                  ));
                },
              ),
              SettingsTile.navigation(
                title: const Text('課題のユーザーキー設定'),
                leading: const Icon(Icons.assignment),
                onPressed: (context) {
                  final formUrl = config.assignmentSetupUrl;
                  final url = Uri.parse(formUrl);
                  launchUrlInAppBrowserView(url);
                },
              ),
            ],
          ),

          // その他
          SettingsSection(
            tiles: <SettingsTile>[
              // お知らせ
              SettingsTile.navigation(
                title: const Text('お知らせ'),
                leading: const Icon(Icons.notifications),
                onPressed: (context) {
                  Navigator.of(context).push(PageRouteBuilder<void>(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AnnouncementScreen(),
                    transitionsBuilder: fromRightAnimation,
                  ));
                },
              ),
              // フィードバック
              SettingsTile.navigation(
                title: const Text('フィードバックを送る'),
                leading: const Icon(Icons.messenger_rounded),
                onPressed: (context) {
                  final formUrl = config.feedbackFormUrl;
                  final url = Uri.parse(formUrl);
                  launchUrlInAppBrowserView(url);
                },
              ),
              // アプリの使い方
              SettingsTile.navigation(
                title: const Text('アプリの使い方'),
                leading: const Icon(Icons.assignment),
                onPressed: (context) {
                  Navigator.of(context).push(PageRouteBuilder<void>(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AppTutorial(),
                    transitionsBuilder: fromRightAnimation,
                  ));
                },
              ),
              // 利用規約
              SettingsTile.navigation(
                title: const Text('利用規約&プライバシーポリシー'),
                leading: const Icon(Icons.verified_user),
                onPressed: (context) {
                  const formUrl = 'https://dotto.web.app/privacypolicy.html';
                  final url = Uri.parse(formUrl);
                  launchUrlInAppBrowserView(url);
                },
              ),
              SettingsTile.navigation(
                title: const Text('ライセンス'),
                leading: const Icon(Icons.info),
                onPressed: (context) {
                  Navigator.of(context).push(PageRouteBuilder<void>(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SettingsLicenseScreen(),
                    transitionsBuilder: fromRightAnimation,
                  ));
                },
              ),
              // バージョン
              SettingsTile.navigation(
                title: const Text('バージョン'),
                leading: const Icon(Icons.info),
                trailing: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Text('${data.version} (${data.buildNumber})');
                    } else {
                      return const Text('');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

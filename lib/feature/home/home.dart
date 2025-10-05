import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/feature/announcement/controller/announcement_from_push_notification_controller.dart';
import 'package:dotto/feature/bus/widget/bus_card_home.dart';
import 'package:dotto/feature/funch/widget/funch_mypage_card.dart';
import 'package:dotto/feature/timetable/controller/two_week_timetable_controller.dart';
import 'package:dotto/feature/timetable/course_cancellation.dart';
import 'package:dotto/feature/timetable/edit_timetable_screen.dart';
import 'package:dotto/feature/timetable/widget/my_page_timetable.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:dotto/widget/file_viewer.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<int> personalTimetableList = [];

  Future<void> launchUrlInAppBrowserView(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Widget infoTile(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: List.generate(children.length, (index) {
          return children[index];
        }),
      ),
    );
  }

  Widget infoButton(
    BuildContext context,
    void Function() onPressed,
    IconData icon,
    String title,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        shadowColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            ClipOval(
              child: Container(
                width: 44,
                height: 44,
                color: customFunColor,
                child: Center(child: Icon(icon, color: Colors.white, size: 24)),
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _showPushNotificationNews(BuildContext context, WidgetRef ref) {
    final announcementUrlFromPushNotification = ref.watch(
      announcementFromPushNotificationProvider,
    );

    if (announcementUrlFromPushNotification == null) {
      return;
    }

    launchUrlInAppBrowserView(announcementUrlFromPushNotification);
  }

  Widget _setTimetableButton() {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      child: Row(
        children: [
          DottoButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder<void>(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const CourseCancellationScreen();
                  },
                  transitionsBuilder: fromRightAnimation,
                ),
              );
            },
            type: DottoButtonType.text,
            child: const Text('休講・補講'),
          ),
          const Spacer(),
          DottoButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    PageRouteBuilder<void>(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const EditTimetableScreen();
                      },
                      transitionsBuilder: fromRightAnimation,
                    ),
                  )
                  .then(
                    (value) => ref
                        .read(twoWeekTimetableNotifierProvider.notifier)
                        .refresh(),
                  );
            },
            type: DottoButtonType.text,
            child: const Text('時間割を編集'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configNotifierProvider);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showPushNotificationNews(context, ref),
    );

    const fileNamePath = <String, String>{
      '学年暦': 'home/academic_calendar.pdf',
      '前期時間割': 'home/timetable_first.pdf',
      '後期時間割': 'home/timetable_second.pdf',
    };
    final infoTiles = <Widget>[
      ...fileNamePath.entries.map(
        (item) => infoButton(
          context,
          () {
            Navigator.of(context).push(
              PageRouteBuilder<void>(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FileViewerScreen(
                    filename: item.key,
                    url: item.value,
                    storage: StorageService.firebase,
                  );
                },
                transitionsBuilder: fromRightAnimation,
              ),
            );
          },
          Icons.picture_as_pdf,
          item.key,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dotto'), centerTitle: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            spacing: 16,
            children: [
              Column(
                children: [const MyPageTimetable(), _setTimetableButton()],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: BusCardHome(),
              ),
              if (config.isFunchEnabled)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: FunchMyPageCard(),
                ),
              infoTile(infoTiles),
            ],
          ),
        ),
      ),
    );
  }
}

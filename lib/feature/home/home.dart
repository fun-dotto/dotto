import 'package:collection/collection.dart';

import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/feature/announcement/controller/news_from_push_notification_controller.dart';
import 'package:dotto/feature/announcement/controller/news_list_controller.dart';
import 'package:dotto/feature/announcement/news_detail.dart';
import 'package:dotto/feature/announcement/widget/my_page_news.dart';
import 'package:dotto/feature/bus/widget/bus_card_home.dart';
import 'package:dotto/feature/funch/funch.dart';
import 'package:dotto/feature/funch/widget/funch_mypage_card.dart';
import 'package:dotto/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/timetable/course_cancellation.dart';
import 'package:dotto/feature/timetable/personal_time_table.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/timetable/widget/my_page_timetable.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:dotto/widget/file_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

final class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<int> personalTimeTableList = [];

  Future<void> launchUrlInExternal(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Widget infoTile(List<Widget> children) {
    final length = children.length;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          for (int i = 0; i < length; i += 3) ...{
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = i; j < i + 3 && j < length; j++) ...{
                  children[j],
                }
              ],
            ),
          },
        ],
      ),
    );
  }

  Widget infoButton(BuildContext context, void Function() onPressed,
      IconData icon, String title) {
    final width = MediaQuery.sizeOf(context).width * 0.26;
    const double height = 100;
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          fixedSize: Size(width, height),
        ),
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 45,
                  height: 45,
                  color: customFunColor,
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPushNotificationNews(BuildContext context, WidgetRef ref) {
    final newsIdFromPushNotification =
        ref.watch(newsFromPushNotificationProvider);
    final newsList = ref.watch(newsListProvider);

    if (newsIdFromPushNotification == null) {
      return;
    }

    newsList.when(
      data: (data) {
        final news =
            data.firstWhereOrNull((e) => e.id == newsIdFromPushNotification);
        if (news == null) {
          return;
        }
        Navigator.of(context)
            .push(
          PageRouteBuilder<void>(
            pageBuilder: (context, animation, secondaryAnimation) =>
                NewsDetailScreen(news),
            transitionsBuilder: fromRightAnimation,
          ),
        )
            .whenComplete(() {
          ref.read(newsFromPushNotificationProvider.notifier).reset();
        });
      },
      loading: () {
        return;
      },
      error: (error, stackTrace) {
        return;
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configControllerProvider);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showPushNotificationNews(context, ref));

    final infoBoxWidth = MediaQuery.sizeOf(context).width * 0.4;

    const fileNamePath = <String, String>{
      // 'バス時刻表': 'home/hakodatebus55.pdf',
      '学年暦': 'home/academic_calendar.pdf',
      '前期時間割': 'home/timetable_first.pdf',
      '後期時間割': 'home/timetable_second.pdf',
    };
    final infoTiles = <Widget>[
      infoButton(context, () {
        Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const CourseCancellationScreen();
            },
            transitionsBuilder: fromRightAnimation,
          ),
        );
      }, Icons.event_busy, '休講情報'),
      if (config.isFunchEnabled)
        infoButton(context, () {
          Navigator.of(context).push(
            PageRouteBuilder<void>(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const FunchScreen();
              },
              transitionsBuilder: fromRightAnimation,
            ),
          );
        }, Icons.lunch_dining_outlined, '学食'),
      ...fileNamePath.entries.map((item) => infoButton(context, () {
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
          }, Icons.picture_as_pdf, item.key)),
    ];

    final twoWeekTimeTableDataNotifier =
        ref.read(twoWeekTimeTableDataProvider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              // 時間割
              const MyPageTimetable(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      PageRouteBuilder<void>(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const PersonalTimeTableScreen();
                        },
                        transitionsBuilder: fromRightAnimation,
                      ),
                    )
                        .then((value) async {
                      twoWeekTimeTableDataNotifier.state =
                          await TimetableRepository()
                              .get2WeekLessonSchedule(ref);
                    });
                  },
                  child: Text(
                    '時間割を設定する ⇀',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const BusCardHome(),
              const SizedBox(height: 20),
              if (config.isFunchEnabled)
                const FunchMyPageCard()
              else
                const SizedBox.shrink(),
              const SizedBox(height: 20),
              const MyPageNews(),
              const SizedBox(height: 20),
              infoTile(infoTiles),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      const formUrl = 'https://forms.gle/ruo8iBxLMmvScNMFA';
                      final url = Uri.parse(formUrl);
                      await launchUrlInExternal(url);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: Size(infoBoxWidth, 80),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      '意見要望\nお聞かせください！',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

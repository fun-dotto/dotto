import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/feature/bus/controller/bus_data_controller.dart';
import 'package:dotto/feature/bus/controller/bus_polling_controller.dart';
import 'package:dotto/feature/bus/controller/bus_stops_controller.dart';
import 'package:dotto/feature/bus/controller/my_bus_stop_controller.dart';
import 'package:dotto/feature/bus/repository/bus_repository.dart';
import 'package:dotto/feature/bus/widget/bus_card_home.dart';
import 'package:dotto/feature/funch/widget/funch_mypage_card.dart';
import 'package:dotto/feature/timetable/controller/timetable_period_style_controller.dart';
import 'package:dotto/feature/timetable/controller/two_week_timetable_controller.dart';
import 'package:dotto/feature/timetable/course_cancellation_screen.dart';
import 'package:dotto/feature/timetable/domain/timetable_period_style.dart';
import 'package:dotto/feature/timetable/edit_timetable_screen.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/timetable/widget/my_page_timetable.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:dotto/widget/web_pdf_viewer.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<int> personalTimetableList = [];

  Future<void> getPersonalLessonIdList() async {
    await TimetableRepository().loadPersonalTimetableList(ref);
  }

  Future<void> getBus() async {
    await ref.read(busStopsProvider.notifier).build();
    await ref.read(busDataProvider.notifier).build();
    await ref.read(myBusStopProvider.notifier).load();
    ref.read(busPollingProvider.notifier).start();
    await BusRepository().changeDirectionOnCurrentLocation(ref);
  }

  Widget _fileButton(
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

  Widget _fileButtons(List<Widget> children) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: List.generate(children.length, (index) {
        return children[index];
      }),
    );
  }

  Widget _linkTile({required String title, required VoidCallback onTap}) {
    return SizedBox(
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3E3E3), width: 0.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ).copyWith(right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chevron_right, color: Colors.black45),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _linkRow() {
    final links = [
      (label: 'HOPE', url: 'https://hope.fun.ac.jp/my/courses.php'),
      (label: '学生ポータル', url: 'https://students.fun.ac.jp/Portal'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const rowGap = 27.0;
        final available = (constraints.maxWidth - rowGap) / 2;
        final tileWidth = available.clamp(0.0, 184.0).toDouble();
        final totalWidth = tileWidth * 2 + rowGap;

        return Align(
          child: SizedBox(
            width: totalWidth,
            child: Row(
              children: [
                SizedBox(
                  width: tileWidth,
                  child: _linkTile(
                    title: links[0].label,
                    onTap: () => launchUrlString(links[0].url),
                  ),
                ),
                const SizedBox(width: rowGap),
                SizedBox(
                  width: tileWidth,
                  child: _linkTile(
                    title: links[1].label,
                    onTap: () => launchUrlString(links[1].url),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _timetableButtons() {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      child: Row(
        children: [
          DottoButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CourseCancellationScreen(),
                  settings: const RouteSettings(
                    name: '/home/course_cancellation',
                  ),
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
                    MaterialPageRoute<void>(
                      builder: (_) => const EditTimetableScreen(),
                      settings: const RouteSettings(
                        name: '/home/edit_timetable',
                      ),
                    ),
                  )
                  .then(
                    (value) =>
                        ref.read(twoWeekTimetableProvider.notifier).refresh(),
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
    getPersonalLessonIdList();
    getBus();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final timetablePeriodStyle = ref.watch(timetablePeriodStyleProvider);

    final fileItems = <(String label, String url, IconData icon)>[
      ('学年暦', config.officialCalendarPdfUrl, Icons.event_note),
      ('時間割 前期', config.timetable1PdfUrl, Icons.calendar_month),
      ('時間割 後期', config.timetable2PdfUrl, Icons.calendar_month),
    ];
    final infoTiles = <Widget>[
      ...fileItems.map(
        (item) => _fileButton(
          context,
          () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => WebPdfViewer(url: item.$2, filename: item.$1),
                settings: RouteSettings(
                  name: '/home/web_pdf_viewer?url=${item.$2}',
                ),
              ),
            );
          },
          item.$3,
          item.$1,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dotto'),
        centerTitle: false,
        actions: [
          timetablePeriodStyle.when(
            data: (style) {
              return Row(
                spacing: 4,
                children: [
                  const Text('時刻を表示'),
                  Switch(
                    value: style == TimetablePeriodStyle.numberAndTime,
                    onChanged: (value) {
                      ref
                          .read(timetablePeriodStyleProvider.notifier)
                          .setStyle(
                            value
                                ? TimetablePeriodStyle.numberAndTime
                                : TimetablePeriodStyle.numberOnly,
                          );
                    },
                  ),
                ],
              );
            },
            error: (_, _) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              spacing: 8,
              children: [const MyPageTimetable(), _timetableButtons()],
            ),
            Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    const BusCardHome(),
                    if (config.isFunchEnabled) ...[
                      const SizedBox(height: 16),
                      const FunchMyPageCard(),
                    ],
                    const SizedBox(height: 16),
                    _fileButtons(infoTiles),
                    const SizedBox(height: 27),
                    _linkRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

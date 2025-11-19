import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/feature/bus/widget/bus_card_home.dart';
import 'package:dotto/feature/funch/widget/funch_mypage_card.dart';
import 'package:dotto/feature/timetable/controller/timetable_period_style_controller.dart';
import 'package:dotto/feature/timetable/controller/two_week_timetable_controller.dart';
import 'package:dotto/feature/timetable/course_cancellation_screen.dart';
import 'package:dotto/feature/timetable/domain/timetable_period_style.dart';
import 'package:dotto/feature/timetable/edit_timetable_screen.dart';
import 'package:dotto/feature/timetable/widget/my_page_timetable.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:dotto/widget/file_viewer.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<int> personalTimetableList = [];

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
    final timetablePeriodStyle = ref.watch(
      timetablePeriodStyleNotifierProvider,
    );

    const fileNamePath = <String, String>{
      '学年暦': 'home/academic_calendar.pdf',
      '前期時間割': 'home/timetable_first.pdf',
      '後期時間割': 'home/timetable_second.pdf',
    };
    final infoTiles = <Widget>[
      ...fileNamePath.entries.map(
        (item) => _fileButton(
          context,
          () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => FileViewerScreen(
                  filename: item.key,
                  url: item.value,
                  storage: StorageService.firebase,
                ),
                settings: RouteSettings(
                  name:
                      '/home/file_viewer?filename=${item.key}&url=${item.value}&storage=firebase',
                ),
              ),
            );
          },
          Icons.picture_as_pdf,
          item.key,
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
                          .read(timetablePeriodStyleNotifierProvider.notifier)
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
                  spacing: 16,
                  children: [
                    const BusCardHome(),
                    if (config.isFunchEnabled) const FunchMyPageCard(),
                    _fileButtons(infoTiles),
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

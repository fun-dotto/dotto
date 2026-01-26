import 'dart:async';

import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/domain/quick_link.dart';
import 'package:dotto/feature/bus/controller/bus_data_controller.dart';
import 'package:dotto/feature/bus/controller/bus_polling_controller.dart';
import 'package:dotto/feature/bus/controller/bus_stops_controller.dart';
import 'package:dotto/feature/bus/controller/my_bus_stop_controller.dart';
import 'package:dotto/feature/bus/repository/bus_repository.dart';
import 'package:dotto/feature/bus/widget/bus_card_home.dart';
import 'package:dotto/feature/funch/widget/funch_mypage_card.dart';
import 'package:dotto/feature/home/component/file_grid.dart';
import 'package:dotto/feature/home/component/file_tile.dart';
import 'package:dotto/feature/home/component/link_grid.dart';
import 'package:dotto/feature/home/component/timetable_buttons.dart';
import 'package:dotto/feature/timetable/controller/timetable_period_style_controller.dart';
import 'package:dotto/feature/timetable/controller/two_week_timetable_controller.dart';
import 'package:dotto/feature/timetable/course_cancellation_screen.dart';
import 'package:dotto/feature/timetable/domain/timetable_period_style.dart';
import 'package:dotto/feature/timetable/edit_timetable_screen.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/timetable/widget/my_page_timetable.dart';
import 'package:dotto/widget/web_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  void initState() {
    super.initState();
    unawaited(getPersonalLessonIdList());
    unawaited(getBus());
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
        (item) => FileTile(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => WebPdfViewer(url: item.$2, filename: item.$1),
                settings: RouteSettings(
                  name: '/home/web_pdf_viewer?url=${item.$2}',
                ),
              ),
            );
          },
          icon: item.$3,
          title: item.$1,
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
              children: [
                const MyPageTimetable(),
                TimetableButtons(
                  onCourseCancellationPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const CourseCancellationScreen(),
                        settings: const RouteSettings(
                          name: '/home/course_cancellation',
                        ),
                      ),
                    );
                  },
                  onEditTimetablePressed: () {
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
                              .read(twoWeekTimetableProvider.notifier)
                              .refresh(),
                        );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  spacing: 16,
                  children: [
                    const BusCardHome(),
                    if (config.isFunchEnabled) ...[
                      const FunchMyPageCard(),
                    ],
                    Column(
                      spacing: 8,
                      children: [
                        FileGrid(children: infoTiles),
                        const LinkGrid(links: QuickLink.links),
                      ],
                    ),
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

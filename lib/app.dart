// import 'package:dotto/domain/timetable.dart';
// import 'package:dotto/domain/timetable_course.dart';
// import 'package:dotto/domain/timetable_course_type.dart';
// import 'package:dotto/domain/timetable_slot.dart';
// import 'package:dotto/feature/home/component/timetable_calendar_view.dart';
import 'package:dotto/feature/root/root_screen.dart';
import 'package:dotto/l10n/app_localizations.dart';
import 'package:dotto_design_system/style/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final now = DateTime.now();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dotto',
      theme: DottoTheme.v2,
      home: const RootScreen(),
      // home: Scaffold(
      //   appBar: AppBar(title: const Text('講義'), centerTitle: false),
      //   body: Padding(
      //     padding: const EdgeInsets.all(16),
      //     child: TimetableCalendarView(
      //       timetables: [
      //         Timetable(
      //           date: DateTime(now.year, now.month, now.day),
      //           courses: [
      //             const TimetableCourse(
      //               slot: TimetableSlot.first,
      //               lessonId: 0,
      //               courseName: '解析学I',
      //               roomName: '講堂',
      //             ),
      //             const TimetableCourse(
      //               slot: TimetableSlot.second,
      //               lessonId: 0,
      //               courseName: '解析学I',
      //               roomName: '講堂',
      //               type: TimetableCourseType.cancelled,
      //             ),
      //             const TimetableCourse(
      //               slot: TimetableSlot.third,
      //               lessonId: 0,
      //               courseName: '解析学I',
      //               roomName: '講堂',
      //             ),
      //             const TimetableCourse(
      //               slot: TimetableSlot.fourth,
      //               lessonId: 0,
      //               courseName: '解析学I',
      //               roomName: '講堂',
      //               type: TimetableCourseType.madeUp,
      //             ),
      //             const TimetableCourse(
      //               slot: TimetableSlot.fifth,
      //               lessonId: 0,
      //               courseName: '解析学I',
      //               roomName: '講堂',
      //             ),
      //           ],
      //         ),
      //       ],
      //       selectedDate: DateTime(now.year, now.month, now.day),
      //       onDateSelected: (date) {},
      //       onCourseSelected: (course) {},
      //     ),
      //   ),
      // ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }
}

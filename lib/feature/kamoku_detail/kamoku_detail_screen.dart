import 'package:dotto/feature/kamoku_detail/kamoku_detail_feedback.dart';
import 'package:dotto/feature/kamoku_detail/kamoku_detail_kakomon_list.dart';
import 'package:dotto/feature/kamoku_detail/kamoku_detail_syllabus.dart';
import 'package:flutter/material.dart';

final class KamokuDetailScreen extends StatelessWidget {
  const KamokuDetailScreen({
    required this.lessonId,
    required this.lessonName,
    required this.isAuthenticated,
    super.key,
    this.kakomonLessonId,
  });

  final int lessonId;
  final String lessonName;
  final int? kakomonLessonId;
  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(lessonName),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(text: 'シラバス'),
              Tab(text: 'レビュー'),
              Tab(text: '過去問'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            KamokuDetailSyllabusScreen(lessonId: lessonId),
            KamokuFeedbackScreen(
              lessonId: lessonId,
              isAuthenticated: isAuthenticated,
            ),
            KamokuDetailKakomonListScreen(
              lessonId: kakomonLessonId ?? lessonId,
              isAuthenticated: isAuthenticated,
            ),
          ],
        ),
      ),
    );
  }
}

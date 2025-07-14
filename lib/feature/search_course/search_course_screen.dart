import 'package:dotto/feature/search_course/widget/kamoku_search_action_buttons.dart';
import 'package:dotto/feature/search_course/widget/kamoku_search_box.dart';
import 'package:dotto/feature/search_course/widget/kamoku_search_filter_section.dart';
import 'package:dotto/feature/search_course/widget/kamoku_search_results_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseScreen extends ConsumerWidget {
  const SearchCourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: KamokuSearchBox(),
              ),
              KamokuSearchFilterSection(),
              KamokuSearchActionButtons(),
              KamokuSearchResultsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

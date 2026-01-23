import 'package:dotto/feature/kamoku_detail/repository/kamoku_detail_repository.dart';
import 'package:flutter/material.dart';

final class KamokuDetailSyllabusScreen extends StatelessWidget {
  const KamokuDetailSyllabusScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: KamokuDetailRepository().fetchDetails(lessonId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final details = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  ...details.keys.map((e) {
                    if (details[e] is String) {
                      return syllabusItem(context, e, details[e] as String?);
                    }
                    return Container();
                  }),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget syllabusItem(BuildContext context, String title, String? value) {
    if (value == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        SelectableText(value),
        const Divider(),
      ],
    );
  }
}

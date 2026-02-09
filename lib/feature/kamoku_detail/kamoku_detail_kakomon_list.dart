import 'package:dotto/feature/kamoku_detail/widget/kamoku_detail_kakomon_list_objects.dart';
import 'package:dotto/helper/s3_repository.dart';
import 'package:flutter/material.dart';

final class KamokuDetailKakomonListScreen extends StatelessWidget {
  const KamokuDetailKakomonListScreen({required this.lessonId, required this.isAuthenticated, super.key});

  final int lessonId;
  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isAuthenticated
            ? FutureBuilder(
                future: S3Repository().getListObjectsKey(url: lessonId.toString()),
                builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('過去問はありません'));
                    }
                    return ListView(
                      children: snapshot.data!.map((e) => KamokuDetailKakomonListObjects(url: e)).toList(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return const SizedBox.shrink();
                },
              )
            : const Text('未来大Googleアカウントでログインが必要です'),
      ),
    );
  }
}

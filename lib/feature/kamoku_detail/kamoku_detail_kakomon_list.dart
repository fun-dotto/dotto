import 'package:dotto/feature/kamoku_detail/repository/kamoku_detail_repository.dart';
import 'package:dotto/feature/kamoku_detail/widget/kamoku_detail_kakomon_list_objects.dart';
import 'package:dotto/helper/s3_repository.dart';
import 'package:flutter/material.dart';

final class KamokuDetailKakomonListScreen extends StatefulWidget {
  const KamokuDetailKakomonListScreen({required this.url, super.key});
  final int url;

  @override
  State<KamokuDetailKakomonListScreen> createState() =>
      _KamokuDetailKakomonListScreenState();
}

final class _KamokuDetailKakomonListScreenState
    extends State<KamokuDetailKakomonListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (KamokuDetailRepository().isLoggedinGoogle())
            ? FutureBuilder(
                future: S3Repository().getListObjectsKey(
                  url: widget.url.toString(),
                ),
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<List<String>> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return const Center(child: Text('過去問はありません'));
                        }
                        return ListView(
                          children: snapshot.data!
                              .map(
                                (e) => KamokuDetailKakomonListObjects(url: e),
                              )
                              .toList(),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
              )
            : const Text('未来大Googleアカウントでログインが必要です'),
      ),
    );
  }
}

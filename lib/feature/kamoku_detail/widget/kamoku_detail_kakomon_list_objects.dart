import 'package:dotto/widget/file_viewer.dart';
import 'package:flutter/material.dart';

final class KamokuDetailKakomonListObjects extends StatefulWidget {
  const KamokuDetailKakomonListObjects({required this.url, super.key});
  final String url;

  @override
  State<KamokuDetailKakomonListObjects> createState() =>
      _KamokuDetailKakomonListObjectsState();
}

final class _KamokuDetailKakomonListObjectsState
    extends State<KamokuDetailKakomonListObjects> {
  bool _checkbox = false;

  @override
  Widget build(BuildContext context) {
    final exp = RegExp(r'/(.*)$');
    final match = exp.firstMatch(widget.url);
    final filename = match![1] ?? widget.url;
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => FileViewerScreen(
                  url: widget.url,
                  filename: filename,
                  storage: StorageService.cloudflare,
                ),
                settings: RouteSettings(
                  name:
                      '/course/course_detail/past_exam/file_viewer?filename=$filename&url=${widget.url}&storage=cloudflare',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ListTile(
              title: Text(filename),
              leading: Checkbox(
                value: _checkbox,
                onChanged: (bool? value) {
                  setState(() {
                    _checkbox = value!;
                  });
                },
              ),
            ),
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}

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
              PageRouteBuilder<void>(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FileViewerScreen(
                    url: widget.url,
                    filename: filename,
                    storage: StorageService.cloudflare,
                  );
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0, 1); // 下から上
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: Curves.easeInOut));
                  final offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
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
        const Divider(
          height: 0,
        )
      ],
    );
  }
}

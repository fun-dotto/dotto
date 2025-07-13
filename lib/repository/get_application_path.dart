import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getApplicationFilePath(String path) async {
  final appDocDir = await getTemporaryDirectory();
  final splitPath = split(path);
  if (splitPath.length > 1) {
    final buffer = StringBuffer(appDocDir.path);
    for (var i = 0; i < splitPath.length - 1; i++) {
      buffer.write('/${splitPath[i]}');
      final d = Directory(buffer.toString());
      if (!d.existsSync()) {
        await d.create();
      }
    }
  }
  return '${appDocDir.path}/$path';
}

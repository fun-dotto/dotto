import 'dart:io';

import 'package:dotto/asset.dart';
import 'package:dotto/helper/local_repository.dart';
import 'package:flutter/services.dart';

final class SyllabusDatabaseConfig {
  factory SyllabusDatabaseConfig() {
    return _instance;
  }

  SyllabusDatabaseConfig._internal();

  static final SyllabusDatabaseConfig _instance = SyllabusDatabaseConfig._internal();

  String _path = '';

  Future<String> getDBPath() async {
    if (_path.isNotEmpty) {
      return _path;
    }

    final data = await rootBundle.load(Asset.syllabus);
    final path = await LocalRepository().getApplicationFilePath('syllabus.db');
    final List<int> bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes);

    return _path = path;
  }
}

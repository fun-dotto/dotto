import 'dart:io';

import 'package:dotto/asset.dart';
import 'package:dotto/repository/get_application_path.dart';
import 'package:flutter/services.dart';

final class SyllabusDatabaseConfig {
  factory SyllabusDatabaseConfig() {
    return _instance;
  }

  SyllabusDatabaseConfig._internal();

  static final SyllabusDatabaseConfig _instance =
      SyllabusDatabaseConfig._internal();

  String _dbPath = '';

  Future<String> getDBPath() async {
    if (_dbPath.isNotEmpty) {
      return _dbPath;
    }

    final data = await rootBundle.load(Asset.syllabus);
    final copiedDbPath = await getApplicationFilePath('syllabus.db');
    final List<int> bytes = data.buffer.asUint8List();
    await File(copiedDbPath).writeAsBytes(bytes);

    return _dbPath = copiedDbPath;
  }
}

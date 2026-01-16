import 'package:dotto/domain/timetable.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class HomeService {
  HomeService(this.ref);

  final Ref ref;

  Future<List<Timetable>> getTimetables() async {
    return ref.read(timetableRepositoryProvider).getTimetables();
  }
}

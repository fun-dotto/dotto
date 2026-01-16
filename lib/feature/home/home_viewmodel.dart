import 'package:dotto/feature/home/home_service.dart';
import 'package:dotto/feature/home/home_viewstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
final class HomeViewModel extends _$HomeViewModel {
  late final HomeService _service;

  @override
  Future<HomeViewState> build() async {
    _service = HomeService(ref);
    final timetables = await _service.getTimetables();
    return HomeViewState(timetables: timetables);
  }

  Future<void> onRefresh() async {
    state = await AsyncValue.guard(() async {
      final timetables = await _service.getTimetables();
      return HomeViewState(timetables: timetables);
    });
  }
}

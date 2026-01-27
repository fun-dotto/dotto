import 'package:dotto/feature/home/home_service.dart';
import 'package:dotto/feature/home/home_viewstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
final class HomeViewModel extends _$HomeViewModel {
  late final HomeService _service;

  @override
  HomeViewState build() {
    _service = HomeService(ref);
    final now = DateTime.now();
    final selectedDate = DateTime(now.year, now.month, now.day);
    return HomeViewState(
      timetables: AsyncValue.loading(),
      selectedDate: selectedDate,
    );
  }

  Future<void> onAppear() async {
    await _refresh();
  }

  void onDateSelected(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  Future<void> _refresh() async {
    state = state.copyWith(timetables: const AsyncValue.loading());
    final timetables = await AsyncValue.guard(() async {
      return _service.getTimetables();
    });
    state = state.copyWith(timetables: timetables);
  }
}

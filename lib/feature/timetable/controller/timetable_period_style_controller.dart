import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/timetable/domain/timetable_period_style.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'timetable_period_style_controller.g.dart';

@riverpod
final class TimetablePeriodStyleNotifier
    extends _$TimetablePeriodStyleNotifier {
  @override
  Future<TimetablePeriodStyle> build() async {
    final styleString = await UserPreferenceRepository.getString(
      UserPreferenceKeys.timetablePeriodStyle,
    );
    return TimetablePeriodStyle.fromString(styleString);
  }

  Future<void> setStyle(TimetablePeriodStyle style) async {
    state = AsyncValue.data(style);
    await UserPreferenceRepository.setString(
      UserPreferenceKeys.timetablePeriodStyle,
      style.toString(),
    );
  }

  Future<void> toggle() async {
    final currentStyle =
        state.value ??
        await UserPreferenceRepository.getString(
          UserPreferenceKeys.timetablePeriodStyle,
        );
    final newStyle = currentStyle == TimetablePeriodStyle.numberOnly
        ? TimetablePeriodStyle.numberWithTime
        : TimetablePeriodStyle.numberOnly;
    await setStyle(newStyle);
  }
}

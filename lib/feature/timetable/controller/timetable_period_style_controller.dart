import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/timetable/domain/timetable_period_style.dart';
import 'package:dotto/helper/logger.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'timetable_period_style_controller.g.dart';

@riverpod
final class TimetablePeriodStyleNotifier
    extends _$TimetablePeriodStyleNotifier {
  @override
  Future<TimetablePeriodStyle> build() async {
    final timetablePeriodStyleKey = await UserPreferenceRepository.getString(
      UserPreferenceKeys.timetablePeriodStyle,
    );

    final style =
        TimetablePeriodStyle.fromKey(
          timetablePeriodStyleKey ?? TimetablePeriodStyle.numberOnly.key,
        ) ??
        TimetablePeriodStyle.numberOnly;

    await ref
        .read(loggerProvider)
        .logBuiltTimetableSetting(timetablePeriodStyle: style);

    return style;
  }

  Future<void> setStyle(TimetablePeriodStyle style) async {
    state = AsyncValue.data(style);

    await UserPreferenceRepository.setString(
      UserPreferenceKeys.timetablePeriodStyle,
      style.key,
    );

    await ref
        .read(loggerProvider)
        .logSetTimetableSetting(timetablePeriodStyle: style);
  }
}

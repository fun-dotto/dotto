import 'package:dotto/controller/analytics_controller.dart';
import 'package:dotto/domain/analytics_event_keys.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/timetable/domain/timetable_period_style.dart';
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

    switch (style) {
      case TimetablePeriodStyle.numberOnly:
        await ref
            .read(analyticsControllerProvider.notifier)
            .logEvent(
              key: AnalyticsEventKeys.timetablePeriodStyleBuiltWithNumberOnly,
            );

      case TimetablePeriodStyle.numberAndTime:
        await ref
            .read(analyticsControllerProvider.notifier)
            .logEvent(
              key:
                  AnalyticsEventKeys.timetablePeriodStyleBuiltWithNumberAndTime,
            );
    }

    return style;
  }

  Future<void> setStyle(TimetablePeriodStyle style) async {
    state = AsyncValue.data(style);

    await UserPreferenceRepository.setString(
      UserPreferenceKeys.timetablePeriodStyle,
      style.key,
    );

    switch (style) {
      case TimetablePeriodStyle.numberOnly:
        await ref
            .read(analyticsControllerProvider.notifier)
            .logEvent(
              key: AnalyticsEventKeys.timetablePeriodStyleChangedToNumberOnly,
            );

      case TimetablePeriodStyle.numberAndTime:
        await ref
            .read(analyticsControllerProvider.notifier)
            .logEvent(
              key:
                  AnalyticsEventKeys.timetablePeriodStyleChangedToNumberAndTime,
            );
    }
  }
}

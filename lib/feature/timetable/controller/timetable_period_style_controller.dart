import 'package:dotto/controller/analytics_controller.dart';
import 'package:dotto/domain/analytics_event_keys.dart';
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
    final styleIndex = await UserPreferenceRepository.getInt(
      UserPreferenceKeys.timetablePeriodStyle,
    );
    final style = TimetablePeriodStyle.values[styleIndex ?? 0];
    await ref.read(analyticsControllerProvider.notifier).logEvent(
      AnalyticsEventKeys.timetablePeriodStyleBuilt,
      {'style': style.name},
    );
    return style;
  }

  Future<void> setStyle(TimetablePeriodStyle style) async {
    state = AsyncValue.data(style);
    await UserPreferenceRepository.setInt(
      UserPreferenceKeys.timetablePeriodStyle,
      style.index,
    );
    await ref.read(analyticsControllerProvider.notifier).logEvent(
      AnalyticsEventKeys.timetablePeriodStyleChanged,
      {'style': style.name},
    );
  }
}

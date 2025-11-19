import 'package:freezed_annotation/freezed_annotation.dart';

part 'debug_view_model_state.freezed.dart';

@freezed
abstract class DebugViewModelState with _$DebugViewModelState {
  const factory DebugViewModelState({
    required String? appCheckAccessToken,
    required String? idToken,
  }) = _DebugViewModelState;
}

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/assignment/controller/hope_continuity_text_editing_controller.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'hope_user_key_controller.g.dart';

@riverpod
final class HopeUserKeyNotifier extends _$HopeUserKeyNotifier {
  @override
  Future<String> build() async {
    final userKey = await UserPreferenceRepository.getString(UserPreferenceKeys.userKey) ?? '';
    ref.read(hopeContinuityTextEditingControllerProvider).text = userKey;
    return userKey;
  }

  Future<void> set(String userKey) async {
    final userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');
    if (userKey.isNotEmpty && !userKeyPattern.hasMatch(userKey)) {
      throw Exception('Invalid user key format.');
    }
    await UserPreferenceRepository.setString(UserPreferenceKeys.userKey, userKey);
  }
}

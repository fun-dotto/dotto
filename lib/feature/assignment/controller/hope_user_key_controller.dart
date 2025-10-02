import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'hope_user_key_controller.g.dart';

@riverpod
final class HopeUserKeyNotifier extends _$HopeUserKeyNotifier {
  @override
  Future<String> build() async {
    return await UserPreferenceRepository.getString(
          UserPreferenceKeys.userKey,
        ) ??
        '';
  }

  Future<void> set(String userKey) async {
    final userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');
    if (!userKeyPattern.hasMatch(userKey)) {
      throw Exception('Invalid user key format.');
    }
    await UserPreferenceRepository.setString(
      UserPreferenceKeys.userKey,
      userKey,
    );
  }
}

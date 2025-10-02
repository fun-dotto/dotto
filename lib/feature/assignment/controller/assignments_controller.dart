import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/assignment/domain/kadai.dart';
import 'package:dotto/feature/assignment/repository/assignment_repository.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'assignments_controller.g.dart';

@riverpod
final class AssignmentsNotifier extends _$AssignmentsNotifier {
  @override
  Future<List<KadaiList>> build() async {
    final userKey = await UserPreferenceRepository.getString(
      UserPreferenceKeys.userKey,
    );
    if (userKey == null || userKey.isEmpty)
      throw Exception('User key is not set.');
    return AssignmentRepository().getKadaiFromFirebase();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

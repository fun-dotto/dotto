import 'package:dotto/feature/assignment/domain/kadai.dart';
import 'package:dotto/repository/firebase_realtime_database_repository.dart';
import 'package:dotto/repository/setting_user_info.dart';

final class AssignmentRepository {
  const AssignmentRepository();

  Future<List<KadaiList>> getKadaiFromFirebase() async {
    final userKey = 'dotto_hope_user_key_'
        '${await UserPreferences.getString(UserPreferenceKeys.userKey)}';
    final kadaiList = <Kadai>[];
    final snapshot = await FirebaseRealtimeDatabaseRepository()
        .getData('hope/users/$userKey/data');
    if (snapshot.exists) {
      final data = snapshot.value! as Map;
      for (final entry in data.entries) {
        kadaiList.add(Kadai.fromFirebase(entry.key as String,
            Map<String, dynamic>.from(entry.value as Map)));
      }
    } else {
      throw Exception();
    }
    kadaiList.sort((a, b) {
      if (a.endtime == null) {
        return 1;
      }
      if (b.endtime == null) {
        return -1;
      }
      if (a.endtime!.compareTo(b.endtime!) == 0) {
        if (a.courseId!.compareTo(b.courseId!) == 0) {
          return a.name!.compareTo(b.name!);
        }
        return a.courseId!.compareTo(b.courseId!);
      }
      return a.endtime!.compareTo(b.endtime!);
    });
    int? courseId;
    DateTime? endtime;
    final kadaiListTmp = <Kadai>[];
    final returnList = <KadaiList>[];
    for (final kadai in kadaiList) {
      if (endtime == kadai.endtime && courseId == kadai.courseId) {
        kadaiListTmp.add(kadai);
      } else {
        if (courseId != null) {
          if (kadaiListTmp.isNotEmpty) {
            returnList.add(KadaiList(courseId, kadaiListTmp[0].courseName!,
                endtime, List.of(kadaiListTmp)));
            kadaiListTmp.clear();
          }
        }
        courseId = kadai.courseId;
        endtime = kadai.endtime;
        kadaiListTmp.add(kadai);
      }
    }
    return returnList;
  }
}

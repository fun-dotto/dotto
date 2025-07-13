import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/feature/funch/domain/firestore_funch_menu.dart';
import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/utility/datetime.dart';
import 'package:dotto/repository/read_json_file.dart';

abstract interface class FunchRepositoryInterface {
  Future<List<FunchCommonMenu>> getAllCommonMenu();
  Future<List<FunchOriginalMenu>> getAllOriginalMenu();
  Future<Map<String, FirestoreFunchMenu>> getMenuFromFirestore(
    MenuCollection collection,
    DateTime from,
    DateTime to,
  );
}

final class FunchRepositoryImpl implements FunchRepositoryInterface {
  @override
  Future<List<FunchCommonMenu>> getAllCommonMenu() async {
    const fileName = 'funch/menu.json';
    final jsonString = await readJsonFile(fileName);
    final List<dynamic> jsonData = json.decode(jsonString) as List<dynamic>;
    return jsonData
        .map((e) => FunchCommonMenu.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<FunchOriginalMenu>> getAllOriginalMenu() async {
    final ref = FirebaseFirestore.instance.collection('funch_original_menu');
    final data = await ref.get();
    return data.docs.map((e) {
      final map = e.data();
      return FunchOriginalMenu.fromJson(
        {
          'id': e.id,
          'name': map['name'],
          'category_id': map['category_id'],
          'prices': map['prices'],
        },
      );
    }).toList();
  }

  @override
  Future<Map<String, FirestoreFunchMenu>> getMenuFromFirestore(
    MenuCollection collection,
    DateTime from,
    DateTime to,
  ) async {
    final ref = FirebaseFirestore.instance.collection(collection.name);
    DateTime correctedDateFrom;
    DateTime correctedDateTo;
    switch (collection) {
      case MenuCollection.monthly:
        correctedDateFrom = DateTimeUtility.firstDateOfMonth(from);
        correctedDateTo = DateTimeUtility.firstDateOfMonth(DateTime(
          to.year,
          to.month + 1,
          to.day,
        ));

      case MenuCollection.daily:
        correctedDateFrom = DateTimeUtility.startOfDay(from);
        correctedDateTo = DateTimeUtility.startOfDay(DateTime(
          to.year,
          to.month,
          to.day + 1,
        ));
    }
    final query = ref
        .where('date', isGreaterThanOrEqualTo: correctedDateFrom)
        .where('date', isLessThan: correctedDateTo);
    final data = await query.get();
    final firestoreFunchMenuList = <String, FirestoreFunchMenu>{};
    for (final doc in data.docs) {
      final menu = FirestoreFunchMenu.fromJson(doc.data());
      firestoreFunchMenuList[DateTimeUtility.dateKey(menu.date)] = menu;
    }

    return firestoreFunchMenuList;
  }
}

enum MenuCollection {
  monthly('funch_monthly_menu'),
  daily('funch_daily_menu');

  const MenuCollection(this.name);

  final String name;
}

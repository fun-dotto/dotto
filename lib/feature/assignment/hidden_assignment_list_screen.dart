import 'dart:convert';

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/assignment/assignment_date_formatter.dart';
import 'package:dotto/feature/assignment/domain/kadai.dart';
import 'package:dotto/feature/assignment/repository/assignment_repository.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class HiddenAssignmentListScreen extends StatefulWidget {
  const HiddenAssignmentListScreen({
    required this.deletedKadaiLists,
    super.key,
  });

  final List<KadaiList> deletedKadaiLists;

  @override
  State<HiddenAssignmentListScreen> createState() =>
      _HiddenAssignmentListScreenState();
}

final class _HiddenAssignmentListScreenState
    extends State<HiddenAssignmentListScreen> {
  List<int> deleteList = [];
  List<Kadai> hiddenKadai = [];

  Future<void> loadDeleteList() async {
    final jsonString = await UserPreferenceRepository.getString(
      UserPreferenceKeys.kadaiDeleteList,
    );
    if (jsonString != null) {
      setState(() {
        deleteList = List<int>.from(json.decode(jsonString) as List);
      });
    }
  }

  Future<void> saveDeleteList() async {
    await UserPreferenceRepository.setString(
      UserPreferenceKeys.kadaiDeleteList,
      json.encode(deleteList),
    );
  }

  Future<void> hiddenKadaiList() async {
    for (final kadaiList in widget.deletedKadaiLists) {
      for (final kadai in kadaiList.listKadai) {
        if (deleteList.contains(kadai.id)) {
          hiddenKadai.add(kadai);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadDeleteList().then((_) {
      // 非表示の課題リストを生成
      hiddenKadaiList();
      hiddenKadai = hiddenKadai.toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('非表示の課題')),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            setState(() {
              AssignmentRepository().getKadaiFromFirebase();
            });
            hiddenKadaiList();
            hiddenKadai = hiddenKadai.toSet().toList();
          });
        },
        child: hiddenKadai.isEmpty
            ? const Center(child: Text('非表示の課題はありません'))
            : ListView.separated(
                itemCount: hiddenKadai.length,
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  return Slidable(
                    key: UniqueKey(),
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      dismissible: DismissiblePane(
                        onDismissed: () {
                          setState(() {
                            deleteList.remove(hiddenKadai[index].id);
                            hiddenKadai.remove(hiddenKadai[index]);
                            saveDeleteList();
                          });
                        },
                      ),
                      children: [
                        SlidableAction(
                          label: '表示する',
                          backgroundColor: Colors.green,
                          icon: Icons.delete,
                          onPressed: (context) {
                            setState(() {
                              deleteList.remove(hiddenKadai[index].id);
                              hiddenKadai.remove(hiddenKadai[index]);
                              saveDeleteList();
                            });
                          },
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        hiddenKadai[index].name!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hiddenKadai[index].courseName!,
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (hiddenKadai[index].endtime != null)
                            Text(
                              '${AssignmentDateFormatter.string(hiddenKadai[index].endtime!)} まで',
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                      onTap: () {
                        launchUrlString(hiddenKadai[index].url ?? '');
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

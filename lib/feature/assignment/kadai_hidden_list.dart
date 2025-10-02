import 'dart:convert';

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/assignment/domain/kadai.dart';
import 'package:dotto/feature/assignment/repository/assignment_repository.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final class KadaiHiddenScreen extends StatefulWidget {
  const KadaiHiddenScreen({required this.deletedKadaiLists, super.key});

  final List<KadaiList> deletedKadaiLists;

  @override
  State<KadaiHiddenScreen> createState() => _KadaiHiddenScreenState();
}

final class _KadaiHiddenScreenState extends State<KadaiHiddenScreen> {
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

  Future<void> launchUrlInExternal(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  String stringFromDateTime(DateTime? dt) {
    if (dt == null) {
      return '';
    }
    return DateFormat('yyyy年MM月dd日 hh時mm分ss秒').format(dt);
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
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop('back'); // 画面遷移から戻り値を指定
          },
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
      ),
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
            ? Center(
                child: Text(
                  '非表示なし',
                  style: TextStyle(fontSize: deviceWidth * 0.1),
                ),
              )
            : ListView.builder(
                itemCount: hiddenKadai.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Slidable(
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
                        minLeadingWidth: 0,
                        leading: const SizedBox(width: 20),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          hiddenKadai[index].name!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hiddenKadai[index].courseName!,
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (hiddenKadai[index].endtime != null)
                              Text(
                                '終了：${stringFromDateTime(hiddenKadai[index].endtime)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                        onTap: () {
                          final url = Uri.parse(hiddenKadai[index].url!);
                          launchUrlInExternal(url);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

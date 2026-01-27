import 'package:dotto/asset.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';

final class AppTutorial extends StatelessWidget {
  const AppTutorial({required this.onDismissed, super.key});

  final void Function() onDismissed;

  Widget _withImage(
    BuildContext context,
    double topMargin,
    String imagePath,
    String title,
    String body,
    Color backgroundColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: backgroundColor,
              image: DecorationImage(
                image: AssetImage(imagePath),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            // ②Containerを重ねる
            child: Container(
              decoration: BoxDecoration(
                // ③グラデーション
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: const Alignment(0, 0.4),
                  // ④透明→白
                  colors: [Colors.transparent, backgroundColor],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: topMargin),
            child: Column(
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topMargin = MediaQuery.of(context).size.height / 2;
    final backgroundColor = SemanticColor.accentMaterialColor.shade50;
    final pages = [
      PageModel.withChild(
        child: _withImage(
          context,
          topMargin,
          Asset.tutorialHome,
          'ホーム',
          '時間割を設定でき、休講・補講情報などの確認をできます',
          backgroundColor,
        ),
        color: backgroundColor,
      ),
      PageModel.withChild(
        child: _withImage(
          context,
          topMargin,
          Asset.tutorialMap,
          '学内マップ',
          '使用中の教室を確認したり、教員名で検索したりできます',
          backgroundColor,
        ),
        color: backgroundColor,
      ),
      PageModel.withChild(
        child: _withImage(
          context,
          topMargin,
          Asset.tutorialKamoku,
          '科目検索',
          'シラバスから科目を検索できます',
          backgroundColor,
        ),
        color: backgroundColor,
      ),
      PageModel.withChild(
        child: _withImage(
          context,
          topMargin,
          Asset.tutorialKadai,
          'HOPE課題',
          'HOPEで設定を行うことで課題を表示することができます',
          backgroundColor,
        ),
        color: backgroundColor,
      ),
      PageModel.withChild(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(
            'さあ、始めましょう！',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        color: SemanticColor.accentMaterialColor.shade100,
        doAnimateChild: true,
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Dottoの使い方')),
      body: SafeArea(
        child: OverBoard(
          buttonColor: Colors.black,
          activeBulletColor: Colors.black,
          inactiveBulletColor: Colors.black38,
          nextText: 'つぎへ',
          finishText: '閉じる',
          skipText: '閉じる',
          pages: pages,
          skipCallback: onDismissed,
          finishCallback: onDismissed,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

final class AppGuideScreen extends StatelessWidget {
  const AppGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('使い方ガイド')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuideItem(context, icon: Icons.search, text: '科目検索から過去問、シラバス、授業のレビューが見れるよ!'),
            const SizedBox(height: 15),
            _buildGuideItem(context, icon: Icons.map, text: 'マップでは使用中の部屋が色付けされて表示されているよ!'),
            const SizedBox(height: 15),
            _buildGuideItem(context, icon: Icons.assignment, text: '課題に関する機能は下記のサイトから設定を行うことで使用できるようになるよ!'),
            const SizedBox(height: 15),
            _buildGuideItem(context, icon: Icons.login, text: '未来大のGoogleアカウントでログインするとレビューの書き込みができるようになるよ!'),
            const SizedBox(height: 20),
            Center(child: Text('https://dotto.web.app/', style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem(BuildContext context, {required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}

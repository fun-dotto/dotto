import 'package:dotto/feature/announcement/news.dart';
import 'package:dotto/feature/announcement/widget/news_list.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/theme/v1/app_color.dart';
import 'package:flutter/material.dart';

final class MyPageNews extends StatelessWidget {
  const MyPageNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 1),
            blurRadius: 1,
          )
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Text('Dottoからのお知らせ'),
          ),
          const NewsList(
            isHome: true,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              PageRouteBuilder<void>(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const NewsScreen(),
                transitionsBuilder: fromRightAnimation,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'お知らせ一覧',
                    style: TextStyle(
                      color: AppColor.linkTextBlue,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColor.linkTextBlue,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

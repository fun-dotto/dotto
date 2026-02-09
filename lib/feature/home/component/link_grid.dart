import 'package:dotto/domain/quick_link.dart';
import 'package:dotto/feature/home/component/link_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class LinkGrid extends StatelessWidget {
  const LinkGrid({required this.links, super.key});

  final List<QuickLink> links;

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: links.length,
      itemBuilder: (context, index) {
        return LinkTile(
          title: links[index].label,
          icon: links[index].icon,
          onTap: () => launchUrlString(links[index].url, mode: LaunchMode.externalApplication),
        );
      },
    );
  }
}

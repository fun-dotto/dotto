import 'package:dotto/feature/debug/debug_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debugViewModel = ref.watch(debugViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Debug')),
      body: debugViewModel.when(
        data: (data) => ListView(
          children: [
            ListTile(
              title: const Text('App Check Access Token'),
              subtitle: Text(
                data.appCheckAccessToken ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  if (data.appCheckAccessToken == null) return;
                  Clipboard.setData(
                    ClipboardData(text: data.appCheckAccessToken ?? ''),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('クリップボードにコピーしました')),
                  );
                },
              ),
            ),
            ListTile(
              title: const Text('User ID Token'),
              subtitle: Text(
                data.idToken ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  if (data.idToken == null) return;
                  Clipboard.setData(ClipboardData(text: data.idToken ?? ''));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('クリップボードにコピーしました')),
                  );
                },
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

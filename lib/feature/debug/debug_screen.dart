import 'package:dotto/feature/debug/debug_view_model.dart';
import 'package:flutter/material.dart';
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
              subtitle: Text(data.appCheckAccessToken),
            ),
          ],
        ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

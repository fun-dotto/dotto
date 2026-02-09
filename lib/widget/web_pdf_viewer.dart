import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Web上のPDFのURLからPDFを閲覧するWidget
final class WebPdfViewer extends StatefulWidget {
  const WebPdfViewer({required this.url, this.filename, super.key});

  /// PDFのURL
  final String url;

  /// ファイル名（省略時はURLから自動取得）
  final String? filename;

  @override
  State<WebPdfViewer> createState() => _WebPdfViewerState();
}

final class _WebPdfViewerState extends State<WebPdfViewer> with WidgetsBindingObserver {
  String? _filePath;
  Uint8List? _pdfData;
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 0;
  final GlobalKey _iconButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _downloadPdf();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cleanupTempFile();
    super.dispose();
  }

  Future<void> _downloadPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await http.get(Uri.parse(widget.url));

      if (response.statusCode != 200) {
        throw Exception('PDFのダウンロードに失敗しました: ${response.statusCode}');
      }

      final bytes = response.bodyBytes;

      // 一時ファイルに保存
      final tempDir = await getTemporaryDirectory();
      final basename = path.basename(Uri.parse(widget.url).path);
      final filename = widget.filename ?? (basename.isNotEmpty ? basename : 'document.pdf');
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(bytes);

      if (mounted) {
        setState(() {
          _filePath = file.path;
          _pdfData = bytes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _cleanupTempFile() async {
    if (_filePath != null) {
      try {
        final file = File(_filePath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // エラーは無視（一時ファイルの削除失敗は問題ない）
      }
    }
  }

  String _getDisplayTitle() {
    if (widget.filename != null) {
      return widget.filename!;
    }
    final basename = path.basename(Uri.parse(widget.url).path);
    return basename.isNotEmpty ? basename : 'PDF Viewer';
  }

  Future<void> _sharePdf() async {
    if (_filePath == null) {
      return;
    }

    if (context.mounted) {
      final content = _iconButtonKey.currentContext;
      if (content != null) {
        final box = content.findRenderObject() as RenderBox?;
        if (box != null) {
          await Share.shareXFiles([XFile(_filePath!)], sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        } else {
          await Share.shareXFiles([XFile(_filePath!)]);
        }
      } else {
        await Share.shareXFiles([XFile(_filePath!)]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('エラー')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('PDFの読み込みに失敗しました', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(_errorMessage!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _downloadPdf, child: const Text('再試行')),
            ],
          ),
        ),
      );
    }

    if (_filePath == null && _pdfData == null) {
      return const Scaffold(body: Center(child: Text('PDFデータが見つかりません')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getDisplayTitle()),
        actions: <Widget>[
          IconButton(
            key: _iconButtonKey,
            icon: const Icon(Icons.share),
            onPressed: _filePath != null ? _sharePdf : null,
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: PDFView(
          filePath: _filePath,
          pdfData: _pdfData,
          defaultPage: _currentPage,
          autoSpacing: false,
          onError: (error) {
            setState(() {
              _errorMessage = error.toString();
            });
          },
          onPageError: (page, error) {
            setState(() {
              _errorMessage = 'ページ $page の読み込みエラー: ${error.toString()}';
            });
          },
          onPageChanged: (int? page, int? total) {
            setState(() {
              _currentPage = page ?? 0;
            });
          },
        ),
      ),
    );
  }
}

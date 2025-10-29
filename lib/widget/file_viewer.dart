import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotto/repository/firebase_storage_repository.dart';
import 'package:dotto/repository/local_repository.dart';
import 'package:dotto/repository/s3_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum StorageService { cloudflare, firebase }

final class FileViewerScreen extends StatefulWidget {
  const FileViewerScreen({
    required this.url,
    required this.filename,
    required this.storage,
    super.key,
  });
  final String url;
  final String filename;
  final StorageService storage;

  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

final class _FileViewerScreenState extends State<FileViewerScreen> {
  Uint8List? dataUint;
  final GlobalKey _iconButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filename),
        actions: <Widget>[
          IconButton(
            key: _iconButtonKey,
            icon: const Icon(Icons.share),
            onPressed: () async {
              if (dataUint != null ||
                  widget.storage == StorageService.firebase) {
                var path = '';
                if (widget.storage == StorageService.cloudflare) {
                  final temp = await getTemporaryDirectory();
                  path = '${temp.path}/${widget.filename}';
                  File(path).writeAsBytesSync(dataUint! as List<int>);
                } else {
                  path = await LocalRepository().getApplicationFilePath(
                    widget.url,
                  );
                }
                if (context.mounted) {
                  final content = _iconButtonKey.currentContext;
                  if (content != null) {
                    final box = content.findRenderObject() as RenderBox?;
                    if (box != null) {
                      await Share.shareXFiles(
                        [XFile(path)],
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size,
                      );
                    } else {
                      await Share.shareXFiles([XFile(path)]);
                    }
                  }
                }
              }
            },
          ),
        ],
      ),
      body: (widget.storage == StorageService.cloudflare)
          ? FutureBuilder(
              future: getListObjectsString(),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                    if (snapshot.hasData) {
                      return KakomonObjectIfType(
                        url: widget.url,
                        data: snapshot.data,
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
            )
          : FutureBuilder(
              future: getFilePathFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return KakomonObjectIfType(
                      url: widget.url,
                      filepath: snapshot.data,
                    );
                  } else {
                    return const Center(child: Text('エラーが発生しました'));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }

  Future<Uint8List> getListObjectsString() async {
    final stream = await S3Repository().getObject(url: widget.url);
    final memory = <int>[];

    await for (final value in stream) {
      memory.addAll(value);
    }
    dataUint = Uint8List.fromList(memory);
    return Uint8List.fromList(memory);
  }

  Future<String> getFilePathFirebase() async {
    // downloadTask
    await FirebaseStorageRepository().download(widget.url);
    return LocalRepository().getApplicationFilePath(widget.url);
  }
}

final class KakomonObjectIfType extends StatelessWidget {
  const KakomonObjectIfType({
    required this.url,
    super.key,
    this.data,
    this.filepath,
  });
  final String url;
  final Uint8List? data;
  final String? filepath;

  @override
  Widget build(BuildContext context) {
    final exp = RegExp(r'\.(.*)$');
    final match = exp.firstMatch(url);
    final filetype = match![1];
    final imageList = <String>['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    if (filetype != null) {
      if (filetype.toLowerCase() == 'pdf') {
        return PDFScreen(pdfData: data, filePath: filepath);
      } else if (imageList.contains(filetype.toLowerCase())) {
        return ImageScreen(imageData: data);
      } else {
        return const Center(child: Text('表示未対応です。右上よりダウンロードできます。'));
      }
    } else {
      return const Center(child: Text('ERROR'));
    }
  }
}

final class PDFScreen extends StatefulWidget {
  const PDFScreen({super.key, this.pdfData, this.filePath});
  final Uint8List? pdfData;
  final String? filePath;

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

final class _PDFScreenState extends State<PDFScreen>
    with WidgetsBindingObserver {
  // final Completer<PDFViewController> _controller =
  //     Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: PDFView(
        filePath: widget.filePath,
        pdfData: widget.pdfData,
        defaultPage: currentPage,
        autoSpacing: false,
        // 略
      ),
      // 略
    );
  }
}

final class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key, this.imageData, this.filePath});
  final Uint8List? imageData;
  final String? filePath;

  @override
  Widget build(BuildContext context) {
    Image image;
    if (imageData != null) {
      image = Image.memory(imageData!);
    } else {
      image = Image.file(File(filePath!));
    }
    return SizedBox.expand(
      child: InteractiveViewer(maxScale: 10, child: image),
    );
  }
}

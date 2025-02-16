import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';

class HadithPdfView extends StatefulWidget {
  final String url;
  final String title;
  const HadithPdfView({super.key, required this.url, required this.title});

  @override
  State<HadithPdfView> createState() => _HadithPdfViewState();
}

class _HadithPdfViewState extends State<HadithPdfView> {
  @override
  void initState() {
    download();
    super.initState();
  }

  String? pdfPath;
  bool isDownloading = true;

  double downloadProgress = 0;

  download() async {
    String url = widget.url;
    String fileName = url.split('/').last;
    final cachgeDir = await getApplicationCacheDirectory();
    String actualPath = join(cachgeDir.path, fileName);
    if (await File(actualPath).exists()) {
      log(' Exits');
      setState(() {
        pdfPath = actualPath;
        isDownloading = false;
      });
    } else {
      log('dont Exits');
      try {
        String temPath = join(cachgeDir.path, 'tem_$fileName');
        if (await Directory(temPath).exists()) {
          await Directory(temPath).delete();
        }
        await Dio().download(
          widget.url,
          temPath,
          onReceiveProgress: (count, total) {
            setState(() {
              downloadProgress = count / total;
            });
          },
        );
        await File(temPath).rename(actualPath);
        setState(() {
          isDownloading = false;
          pdfPath = actualPath;
        });
      } catch (e) {
        log(e.toString());
      }
    }
    setState(() {
      isDownloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isDownloading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: downloadProgress,
                ),
                const Gap(10),
                Text(
                    'Progress: ${(downloadProgress * 100).toStringAsFixed(2)}%'),
                const Text('Please wait. Downloading...')
              ],
            ))
          : pdfPath == null
              ? const Center(
                  child: Text(
                      'Something went worng. Check your internet connection'))
              : SfPdfViewer.file(File(pdfPath!)),
    );
  }
}

import "dart:async";
import "dart:developer";
import "dart:io";

import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import "package:flutter_pdfview/flutter_pdfview.dart";
import "package:gap/gap.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";
import "package:share_plus/share_plus.dart";
import "package:dio/dio.dart";
import "package:shimmer/shimmer.dart";
import "package:wakelock_plus/wakelock_plus.dart";

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
    WakelockPlus.enable();
    download();
    super.initState();
  }

  String? pdfPath;
  bool isDownloading = true;
  double downloadProgress = 0;
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  Future<void> download() async {
    String url = widget.url;
    String fileName = url.split("/").last;
    final cachgeDir = await getApplicationCacheDirectory();
    String actualPath = p.join(cachgeDir.path, fileName);
    if (await File(actualPath).exists()) {
      log(" Exits");
      setState(() {
        pdfPath = actualPath;
        isDownloading = false;
      });
    } else {
      log("dont Exits");
      try {
        String temPath = p.join(cachgeDir.path, "tem_$fileName");
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
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (pdfPath != null)
            IconButton(
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(
                    files: [
                      XFile(pdfPath!),
                    ],
                    title: widget.title,
                  ),
                );
              },
              icon: const Icon(FluentIcons.share_24_regular),
            ),
        ],
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
                    "Progress: ${(downloadProgress * 100).toStringAsFixed(2)}%"),
                const Text("Please wait. Downloading...")
              ],
            ))
          : pdfPath == null
              ? const Center(
                  child: Text(
                      "Something went worng. Check your internet connection"))
              : Stack(
                  children: <Widget>[
                    PDFView(
                      filePath: pdfPath,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageFling: true,
                      backgroundColor: Colors.grey[200],
                      onRender: (pages) {
                        setState(() {
                          pages = pages;
                          isReady = true;
                        });
                      },
                      onError: (error) {
                        log(error.toString());
                      },
                      onPageError: (page, error) {
                        log("$page: ${error.toString()}");
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onPageChanged: (int? page, int? total) {
                        setState(() {
                          currentPage = page;
                        });
                      },
                    ),
                    if (!isReady)
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (isReady && pages != null)
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: InkWell(
                          onTap: () {
                            _showJumpToPageDialog();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  FluentIcons.edit_24_regular,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const Gap(10),
                                Text(
                                  "Page ${(currentPage ?? 0) + 1} / $pages",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }

  void _showJumpToPageDialog() {
    final TextEditingController pageController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Jump to Page"),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: pageController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter page number (1 - $pages)",
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a page number";
              }
              final int? pageNum = int.tryParse(value);
              if (pageNum == null) {
                return "Please enter a valid number";
              }
              if (pageNum < 1 || pageNum > (pages ?? 0)) {
                return "Page must be between 1 and $pages";
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final int targetPage = int.parse(pageController.text) - 1;
                final controller = await _controller.future;
                await controller.setPage(targetPage);
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text("Go"),
          ),
        ],
      ),
    );
  }
}

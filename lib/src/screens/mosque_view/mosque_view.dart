import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mumin/src/screens/home/controller/user_location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MosqueScreen extends StatefulWidget {
  const MosqueScreen({
    super.key,
  });

  @override
  MosqueScreenState createState() => MosqueScreenState();
}

class MosqueScreenState extends State<MosqueScreen> {
  late String locationUri =
      'https://www.google.com/maps/search/mosque/@${userLocationController.locationData.value?.latitude},${userLocationController.locationData.value?.longitude},15z';

  @override
  void initState() {
    super.initState();
  }

  final UserLocationController userLocationController = Get.find();

  Future<void> launchIntentUrl(String url) async {
    Uri intentUri = Uri.parse(url);
    String? embeddedUrlString = intentUri.queryParameters['link'];

    if (embeddedUrlString != null) {
      String decodedEmbeddedUrl = Uri.decodeFull(embeddedUrlString);
      Uri embeddedUri = Uri.parse(decodedEmbeddedUrl);
      launchUrl(embeddedUri, mode: LaunchMode.externalApplication);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Mosque',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(locationUri))
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(NavigationDelegate(
                onNavigationRequest: (NavigationRequest request) async {
              if (request.url.startsWith('intent://')) {
                launchIntentUrl(request.url);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            })),
        ));
  }
}

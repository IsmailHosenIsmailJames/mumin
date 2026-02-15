import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:mumin/src/screens/home/controller/user_location.dart";
import "package:url_launcher/url_launcher.dart";
import "package:webview_flutter/webview_flutter.dart";

class MosqueScreen extends StatefulWidget {
  const MosqueScreen({
    super.key,
  });

  @override
  MosqueScreenState createState() => MosqueScreenState();
}

class MosqueScreenState extends State<MosqueScreen> {
  late String locationUri =
      "https://www.google.com/maps/search/mosque/@${userLocationController.locationData.value?.latitude},${userLocationController.locationData.value?.longitude},15z";

  @override
  void initState() {
    super.initState();
  }

  final UserLocationController userLocationController = Get.find();

  Future<void> launchIntentUrl(String url) async {
    try {
      if (url.startsWith("intent://")) {
        Uri intentUri = Uri.parse(url);

        // 1. Try 'link' parameter
        String? embeddedUrlString = intentUri.queryParameters["link"];
        if (embeddedUrlString != null) {
          String decodedEmbeddedUrl = Uri.decodeFull(embeddedUrlString);
          Uri embeddedUri = Uri.parse(decodedEmbeddedUrl);
          await launchUrl(embeddedUri, mode: LaunchMode.externalApplication);
          return;
        }

        // 2. Try 'S.browser_fallback_url' parameter
        String? fallbackUrl =
            intentUri.queryParameters["S.browser_fallback_url"];
        if (fallbackUrl != null) {
          String decodedFallbackUrl = Uri.decodeFull(fallbackUrl);
          await launchUrl(Uri.parse(decodedFallbackUrl),
              mode: LaunchMode.externalApplication);
          return;
        }

        // 3. Try to reconstruct from intent://
        int hashIndex = url.indexOf("#Intent;");
        if (hashIndex != -1) {
          String actionPart = url.substring(9, hashIndex);
          String scheme = "https";
          RegExp schemeRegExp = RegExp(r"scheme=([^;]+)");
          Match? match = schemeRegExp.firstMatch(url);
          if (match != null && match.groupCount >= 1) {
            scheme = match.group(1)!;
          }
          await launchUrl(Uri.parse("$scheme://$actionPart"),
              mode: LaunchMode.externalApplication);
          return;
        }
      }

      // Handle other schemes (geo:, maps:, comgooglemaps:, etc.)
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching external URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Mosque",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(locationUri))
            ..setNavigationDelegate(NavigationDelegate(
                onNavigationRequest: (NavigationRequest request) async {
              if (request.url.startsWith("intent://") ||
                  request.url.startsWith("geo:") ||
                  request.url.startsWith("maps:") ||
                  request.url.startsWith("comgooglemaps:")) {
                launchIntentUrl(request.url);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            })),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DailyRamadanPlan extends StatefulWidget {
  final int day;
  const DailyRamadanPlan({super.key, required this.day});

  @override
  State<DailyRamadanPlan> createState() => _DailyRamadanPlanState();
}

class _DailyRamadanPlanState extends State<DailyRamadanPlan> {
  final controllerURL = WebViewController();
  String javascript = '''

var element = document.querySelector('#alim-navbar');
if (element) {
    element.remove();
}

var element = document.querySelector('.donate-section');
if (element) {
    element.remove();
}
var element = document.querySelector('.footer');
if (element) {
    element.remove();
}
var element = document.querySelector('.red-button-hover-style');
if (element) {
    element.remove();
}
var element = document.querySelector('.export-btn');
if (element) {
    element.remove();
}

var elements = document.querySelectorAll('.blue-rounded-button');
for (let i = 0; i < Math.min(2, elements.length); i++) { // Limit to the first 2 or the total number if less
  elements[i].remove();
}

var elements = document.querySelectorAll('.flex.items-center.pt-6.pl-4.w-fit');

// Now you can iterate over the 'elements' NodeList, just like before:
for (let i = 0; i < elements.length; i++) {
  // Do something with each element, e.g.,
  elements[i].remove(); // Hide the element
}

var elements = document.querySelectorAll('.text-white.bg-deep-red.px-4.py-2.rounded-full.red-button-hover-style.truncate');

for (let i = 0; i < elements.length; i++) {
  elements[i].remove(); // Or any other action you want to perform
}


var elements = document.querySelectorAll('.loader-content');

for (let i = 0; i < elements.length; i++) {
  elements[i].remove(); // Or any other action you want to perform
}


''';
  bool isLoading = true;

  @override
  void initState() {
    controllerURL
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            controllerURL.runJavaScript(javascript);
            isLoading = false;
            setState(() {});
          },
          onWebResourceError: (WebResourceError error) {
            //Things to do when the page has error when loading
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://www.alim.org/duas/ramadan-days/${widget.day}/'),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('30 Days Plan'),
      ),
      body: (isLoading)
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(
              controller: controllerURL,
            ),
    );
  }
}

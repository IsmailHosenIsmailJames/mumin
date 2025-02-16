import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:mumin/src/apis/apis.dart';
import 'package:mumin/src/screens/hadith/pdf_view.dart';
import 'package:mumin/src/theme/shapes.dart';

class PartsView extends StatefulWidget {
  final int id;
  final String hadithName;
  const PartsView({super.key, required this.id, required this.hadithName});

  @override
  State<PartsView> createState() => _PartsViewState();
}

class _PartsViewState extends State<PartsView> {
  late List<Map> hadithParts = List<Map<dynamic, dynamic>>.from(
      Hive.box('user_db').get('hadithParts_${widget.id}', defaultValue: []));
  @override
  void initState() {
    getHadithData();
    super.initState();
  }

  getHadithData() async {
    try {
      final response =
          await get(Uri.parse('$baseApi/api/v1/hadith_list/${widget.id}'));
      if (response.statusCode == 200) {
        setState(() {
          hadithParts = List<Map>.from(jsonDecode(response.body)['result']);
        });
        Hive.box('user_db').put('hadithParts_${widget.id}', hadithParts);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hadithName),
      ),
      body: ListView.builder(
        itemCount: hadithParts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: MyAppShapes.borderRadius,
                ),
              ),
              onPressed: () {
                log('$baseApi/hadiths/${hadithParts[index]['file'].toString().split('/').last}');
                Get.to(
                  () => HadithPdfView(
                      url:
                          '$baseApi/hadiths/${hadithParts[index]['file'].toString().split('/').last}',
                      title: hadithParts[index]['name']),
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset('assets/images/hadith.png'),
                  ),
                  const Gap(10),
                  Text(
                    hadithParts[index]['name'],
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

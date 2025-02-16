import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:mumin/src/apis/apis.dart';
import 'package:mumin/src/screens/hadith/parts_view.dart';
import 'package:mumin/src/theme/shapes.dart';

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  List<Map> hadithList = List<Map<dynamic, dynamic>>.from(
      Hive.box('user_db').get('hadithList', defaultValue: []));
  @override
  void initState() {
    getHadithData();
    super.initState();
  }

  getHadithData() async {
    try {
      final response = await get(Uri.parse('${baseApi}/api/v1/hadith_list'));
      if (response.statusCode == 200) {
        setState(() {
          hadithList = List<Map>.from(jsonDecode(response.body)['result']);
        });
        Hive.box('user_db').put('hadithList', hadithList);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadith'),
      ),
      body: hadithList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: hadithList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: MyAppShapes.borderRadius,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: MyAppShapes.borderRadius,
                      ),
                    ),
                    onPressed: () {
                      Get.to(
                        () => PartsView(
                            id: hadithList[index]['id'],
                            hadithName: hadithList[index]['name']),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset('assets/images/hadith.png')),
                          const Gap(10),
                          Text(
                            hadithList[index]['name'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

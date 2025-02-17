import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mumin/src/screens/home/controller/user_location.dart';
import 'package:mumin/src/screens/prayer_time/model/prayer_time_model.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/shapes.dart';

class PrayerTime extends StatefulWidget {
  const PrayerTime({super.key});

  @override
  State<PrayerTime> createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {
  PrayerTimeModel? prayerTimeModel;
  @override
  void initState() {
    getPrayerTimeData();
    super.initState();
  }

  UserLocationController userLocationController = Get.find();

  getPrayerTimeData() async {
    String url =
        'https://muslimsalat.com/${userLocationController.locationData.value!.division.split(' ').first.toLowerCase()}/${DateFormat('yyyy-MM-dd').format(DateTime.now())}.json';
    log(url);
    if (Hive.box('user_db').containsKey(url)) {
      prayerTimeModel = PrayerTimeModel.fromJson(Hive.box('user_db').get(url));
      await Hive.box('user_db').put(url, prayerTimeModel!.toJson());
      setState(() {});
      return;
    }
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      List listOfItems = List.from(jsonDecode(response.body)['items']);
      prayerTimeModel =
          PrayerTimeModel.fromMap(Map<String, dynamic>.from(listOfItems[0]));
      await Hive.box('user_db').put(url, prayerTimeModel!.toJson());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayers Time'),
      ),
      body: Center(
        child: prayerTimeModel == null
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/mosque3.png'),
                    const Text(
                      'Next prayer',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${getNextPrayerTime(prayerTimeModel!).name} ${getNextPrayerTime(prayerTimeModel!).timeOfDay.format(context)}',
                      style: const TextStyle(fontSize: 32),
                    ),
                    const Gap(20),
                    const Row(
                      children: [
                        Gap(10),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Name',
                          ),
                        ),
                        Gap(20),
                        Text(
                          'Time',
                        ),
                      ],
                    ),
                    ...List.generate(
                      getAllPrayerTime(prayerTimeModel!).length,
                      (index) {
                        SinglePrayerTime singlePrayerTime =
                            getAllPrayerTime(prayerTimeModel!)[index];
                        return Container(
                          height: 60,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? MyAppColors.primaryColor
                                    .withValues(alpha: 0.8)
                                : Colors.blue.withValues(alpha: 0.8),
                            borderRadius: MyAppShapes.borderRadius,
                          ),
                          child: Row(
                            children: [
                              const Gap(10),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  singlePrayerTime.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Gap(20),
                              Text(
                                singlePrayerTime.timeOfDay.format(context),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }

  List<SinglePrayerTime> getAllPrayerTime(PrayerTimeModel prayerTimeModel) {
    List<SinglePrayerTime> listOfSinglePrayerTime = [];
    listOfSinglePrayerTime.add(
      SinglePrayerTime(
        name: 'Fajr',
        timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.fajr),
      ),
    );
    listOfSinglePrayerTime.add(
      SinglePrayerTime(
        name: 'Dhuhr',
        timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.dhuhr),
      ),
    );
    listOfSinglePrayerTime.add(
      SinglePrayerTime(
        name: 'Asr',
        timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.asr),
      ),
    );
    listOfSinglePrayerTime.add(
      SinglePrayerTime(
        name: 'Maghrib',
        timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.maghrib),
      ),
    );
    listOfSinglePrayerTime.add(
      SinglePrayerTime(
        name: 'Isha',
        timeOfDay: getTimeOfDayFormTimeString(prayerTimeModel.isha),
      ),
    );
    return listOfSinglePrayerTime;
  }

  SinglePrayerTime getNextPrayerTime(PrayerTimeModel prayerTimeModel) {
    List<SinglePrayerTime> listOfSinglePrayerTime =
        getAllPrayerTime(prayerTimeModel);

    final now = TimeOfDay.now();
    for (int i = 0; i < 4; i++) {
      SinglePrayerTime singlePrayerTime = listOfSinglePrayerTime[i];
      if ((singlePrayerTime.timeOfDay.hour *
              singlePrayerTime.timeOfDay.minute) >=
          (now.hour * now.minute)) {
        return listOfSinglePrayerTime[i + 1];
      }
    }
    return listOfSinglePrayerTime[0];
  }

  TimeOfDay getTimeOfDayFormTimeString(String timeString) {
    List<String> parts = timeString.split(' ');
    String amOrPm = parts.last;
    int hour = int.parse(parts[0].split(':')[0]);
    int min = int.parse(parts[0].split(':')[1]);
    if (amOrPm == 'pm') {
      hour += 12;
    }
    return TimeOfDay(hour: hour, minute: min);
  }
}

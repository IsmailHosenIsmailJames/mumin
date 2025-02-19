import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mumin/src/screens/home/controller/model/user_calander_day_model.dart';
import 'package:mumin/src/screens/home/controller/user_location_calender.dart';
import 'package:mumin/src/theme/shapes.dart';

class RamadanCalenderPage extends StatefulWidget {
  const RamadanCalenderPage({super.key});

  @override
  State<RamadanCalenderPage> createState() => _RamadanCalenderPageState();
}

class _RamadanCalenderPageState extends State<RamadanCalenderPage> {
  final UserLocationCalender userLocationCalender = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ramadan Calender'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/mosque.png'),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(13),
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(18),
                        Text(
                          DateFormat.yMMMEd().format(
                            DateTime.now(),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: MyAppShapes.borderRadius,
                        color: Colors.grey.withValues(
                          alpha: 0.1,
                        ),
                      ),
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(5),
                          const Text(
                            'Sehri',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(20),
                          Text(TimeOfDay.now().format(context))
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: MyAppShapes.borderRadius,
                        color: Colors.grey.withValues(
                          alpha: 0.1,
                        ),
                      ),
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(5),
                          const Text(
                            'Ifter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(25),
                          Text(TimeOfDay.now().format(context))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Gap(10),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 30, child: Text('SL')),
                  SizedBox(width: 80, child: Text('Date')),
                  SizedBox(width: 80, child: Text('Sehri(end)')),
                  SizedBox(width: 80, child: Text('iftar'))
                ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  userLocationCalender.userLocationCalender.value?.length ?? 0,
              itemBuilder: (context, index) {
                RamadanDayModel dayModel =
                    userLocationCalender.userLocationCalender.value![index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: MyAppShapes.borderRadius,
                    color: Colors.grey.withValues(
                      alpha: 0.1,
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          DateFormat.yMMMMd().format(dayModel.date),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          parseTimeString(dayModel.seharEnd.toUpperCase())
                              .format(context),
                        ),
                      ),
                      SizedBox(
                          width: 80,
                          child: Text(
                              parseTimeString(dayModel.ifter).format(context)))
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TimeOfDay parseTimeString(String timeString) {
    DateFormat format = DateFormat("HH:mm:ss.SSS"); // Define the format
    DateTime dateTime =
        format.parse(timeString); // Parse the string into DateTime

    return TimeOfDay.fromDateTime(dateTime); // Convert DateTime to TimeOfDay
  }
}

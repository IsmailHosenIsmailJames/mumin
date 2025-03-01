import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:mumin/src/screens/home/controller/user_location.dart';
import 'package:mumin/src/screens/qibla_direction/controller/compass_value_controller.dart';
import 'package:mumin/src/theme/theme_controller.dart';
import 'package:vector_math/vector_math.dart' show radians;

import '../../core/compass/compass_service.dart';
import 'features/calculate_qibla_direction.dart';

class QiblaCompassScreen extends StatefulWidget {
  const QiblaCompassScreen({super.key});

  @override
  State<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends State<QiblaCompassScreen> {
  final QiblaCalculator _qiblaCalculator = QiblaCalculator();
  final CompassService _compassService = CompassService();

  String? errorMessage;

  final rotationController = Get.put(CompassValueController());

  @override
  void initState() {
    super.initState();
    _getLocationAndQibla();
    _startCompass();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {});
    });
  }

  UserLocationController userLocationController = Get.find();

  Future<void> _getLocationAndQibla() async {
    setState(() {
      rotationController.qbaRotation.value = _qiblaCalculator.getQiblaDirection(
        userLocationController.locationData.value!.latitude,
        userLocationController.locationData.value!.longitude,
      );
      errorMessage = null;
    });
  }

  StreamSubscription? _compassSubscription;

  void _startCompass() {
    _compassSubscription = _compassService.getCompassStream().listen(
      (CompassEvent event) {
        rotationController.compassRotation.value = event.heading;
      },
      onError: (error) {
        if (kDebugMode) {
          print('Compass error: $error');
        }
        errorMessage =
            'Compass sensor error: $error. Please ensure your device has a compass sensor.';
        rotationController.compassRotation.value = null;
      },
    );
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  AppThemeController appThemeController = Get.put(AppThemeController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    dev.log(rotationController.qbaRotation.value?.toString() ?? 'Not Found');

    return Scaffold(
      appBar: AppBar(title: const Text('Qibla Compass')),
      body: Center(
        child: errorMessage != null
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : (rotationController.qbaRotation.value == null ||
                    rotationController.compassRotation.value == null)
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: size.width,
                    height: size.width,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: size.width * 0.7,
                            height: size.width * 0.7,
                            child: Image.asset('assets/images/compass.png'),
                          ),
                        ),
                        Obx(
                          () => Transform.rotate(
                            angle: radians(
                              _getNeedleRotationAngle(
                                rotationController.qbaRotation.value!,
                                rotationController.compassRotation.value!,
                              ),
                            ),
                            child: Center(
                              child: SizedBox(
                                height: size.width * 0.55,
                                width: size.width * 0.55,
                                child: Image.asset(
                                  'assets/images/compass_needle.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: radians(
                            (rotationController.qbaRotation.value! + 90) % 360,
                          ),
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset('assets/images/qaba.png'),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: radians(
                            (rotationController.qbaRotation.value! + 90) % 360,
                          ),
                          child: Center(
                            child: Container(
                              height: size.width * 0.73,
                              width: size.width * 0.73,
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 50,
                                width: 5,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 17, 0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  double _getNeedleRotationAngle(double qiblaDirection, double compassHeading) {
    double rotationAngle = (qiblaDirection - compassHeading);
    return rotationAngle;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/theme_controller.dart';
import 'package:vector_math/vector_math.dart' show radians;

import '../../../core/compass/compass_service.dart';
import '../../../core/location/location_service.dart';
import 'features/calculate_qibla_direction.dart';

class QiblaCompassScreen extends StatefulWidget {
  const QiblaCompassScreen({super.key});

  @override
  State<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends State<QiblaCompassScreen> {
  final LocationService _locationService = LocationService();
  final QiblaCalculator _qiblaCalculator = QiblaCalculator();
  final CompassService _compassService = CompassService();

  double? qiblaDirection;
  double? compassHeading;
  Position? currentLocation;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getLocationAndQibla();
    _startCompass();
  }

  Future<void> _getLocationAndQibla() async {
    currentLocation = await _locationService.getCurrentLocation();
    if (currentLocation != null) {
      setState(() {
        qiblaDirection = _qiblaCalculator.getQiblaDirection(
          currentLocation!.latitude,
          currentLocation!.longitude,
        );
        errorMessage = null;
      });
    } else {
      setState(() {
        errorMessage =
            'Could not get location. Please ensure location services are enabled and permissions are granted.';
        qiblaDirection = null;
      });
    }
  }

  StreamSubscription? _compassSubscription;

  void _startCompass() {
    _compassSubscription = _compassService.getCompassStream().listen(
      (CompassEvent event) {
        setState(() {
          compassHeading = event.heading;
        });
      },
      onError: (error) {
        print('Compass error: $error');
        setState(() {
          errorMessage =
              'Compass sensor error: $error. Please ensure your device has a compass sensor.';
          compassHeading = null;
        });
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
    return Scaffold(
      appBar: AppBar(title: const Text('Qibla Compass')),
      body: Center(
        child:
            errorMessage != null
                ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                : (qiblaDirection == null || compassHeading == null)
                ? const CircularProgressIndicator()
                : Obx(
                  () => SizedBox(
                    height: 300,
                    width: 300,
                    child: SvgPicture.asset(
                      'assets/svg/compass.svg',
                      color:
                          appThemeController.isDark.value
                              ? MyAppColors.backgroundLightColor
                              : MyAppColors.backgroundDarkColor,
                    ),

                    // Transform.rotate(
                    //   angle: radians(_getNeedleRotationAngle()),
                    //   child: Stack(
                    //     alignment: Alignment.center,
                    //     children: [
                    //       Transform.rotate(
                    //         angle: radians(-10),
                    //         child: Image.asset(
                    //           'assets/images/compass.png',
                    //           width: 300,
                    //           height: 300,
                    //         ),
                    //       ),
                    //       Container(
                    //         height: 250,
                    //         width: 250,
                    //         alignment: Alignment.topCenter,
                    //         child: Image.asset(
                    //           'assets/images/qaba.png',
                    //           width: 50,
                    //           height: 50,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
      ),
    );
  }

  double _getNeedleRotationAngle() {
    if (qiblaDirection == null || compassHeading == null) {
      return 0;
    }

    double rotationAngle = (qiblaDirection! - compassHeading!);
    return rotationAngle;
  }
}

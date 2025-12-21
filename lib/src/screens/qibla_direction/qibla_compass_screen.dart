import "dart:async";
import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_compass/flutter_compass.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:mumin/src/screens/home/controller/user_location.dart";
import "package:mumin/src/screens/qibla_direction/controller/compass_value_controller.dart";
import "package:mumin/src/theme/colors.dart";
import "package:vibration/vibration.dart";

import "features/calculate_qibla_direction.dart";

class QiblaCompassScreen extends StatefulWidget {
  const QiblaCompassScreen({super.key});

  @override
  State<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends State<QiblaCompassScreen>
    with SingleTickerProviderStateMixin {
  final QiblaCalculator _qiblaCalculator = QiblaCalculator();
  final rotationController = Get.put(CompassValueController());
  final userLocationController = Get.find<UserLocationController>();

  String? errorMessage;
  StreamSubscription? _compassSubscription;

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  Timer? _debounceTimer;
  bool _isAligned = false;
  bool _hasVibrated = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    _getLocationAndQibla();
    _startCompass();
  }

  Future<void> _getLocationAndQibla() async {
    if (userLocationController.locationData.value != null) {
      setState(() {
        rotationController.qbaRotation.value =
            _qiblaCalculator.getQiblaDirection(
          userLocationController.locationData.value!.latitude,
          userLocationController.locationData.value!.longitude,
        );
        errorMessage = null;
      });
    }
  }

  void _startCompass() {
    _compassSubscription = FlutterCompass.events?.listen(
      (CompassEvent event) {
        if (event.heading != null) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 50), () {
            setState(() {
              rotationController.compassRotation.value = event.heading;
            });

            _animController.forward().then((_) => _animController.reverse());
            _checkAlignment();
          });
        }
      },
      onError: (error) {
        setState(() {
          errorMessage =
              "Compass sensor error. Please ensure your device has a compass sensor.";
          rotationController.compassRotation.value = null;
        });
      },
    );
  }

  void _checkAlignment() async {
    if (rotationController.qbaRotation.value == null ||
        rotationController.compassRotation.value == null) {
      return;
    }

    final diff = _getAngleDifference(
      rotationController.qbaRotation.value!,
      rotationController.compassRotation.value!,
    ).abs();

    final wasAligned = _isAligned;
    _isAligned = diff <= 5.0;

    if (_isAligned && !wasAligned && !_hasVibrated) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator) {
        Vibration.vibrate(duration: 200);
      }
      HapticFeedback.mediumImpact();
      _hasVibrated = true;
    } else if (!_isAligned) {
      _hasVibrated = false;
    }
  }

  double _getAngleDifference(double qibla, double compass) {
    double diff = (qibla - compass) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return diff;
  }

  double _calculateDistanceToKaaba() {
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;

    if (userLocationController.locationData.value == null) return 0;

    final lat = userLocationController.locationData.value!.latitude;
    final lon = userLocationController.locationData.value!.longitude;

    const p = 0.017453292519943295;
    final a = 0.5 -
        math.cos((kaabaLat - lat) * p) / 2 +
        math.cos(lat * p) *
            math.cos(kaabaLat * p) *
            (1 - math.cos((kaabaLon - lon) * p)) /
            2;

    return 12742 * math.asin(math.sqrt(a));
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _debounceTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.grey[50];
    final textColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Qibla Compass",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: errorMessage != null
          ? _buildErrorState(textColor, cardColor, isDark)
          : (rotationController.qbaRotation.value == null ||
                  rotationController.compassRotation.value == null)
              ? _buildLoadingState(textColor)
              : _buildCompassView(isDark, textColor, cardColor),
    );
  }

  Widget _buildErrorState(Color textColor, Color? cardColor, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                  });
                  _getLocationAndQibla();
                  _startCompass();
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyAppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(Color textColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: MyAppColors.primaryColor,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Finding Qibla direction...",
            style: TextStyle(
              color: textColor.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassView(bool isDark, Color textColor, Color? cardColor) {
    final distance = _calculateDistanceToKaaba();

    return Column(
      children: [
        // Location Info Card
        _buildLocationCard(isDark, textColor, cardColor, distance),

        const SizedBox(height: 20),

        // Compass
        Expanded(
          child: Center(
            child: Obx(() => _buildCompass(isDark, textColor)),
          ),
        ),

        // Bottom Info
        _buildBottomInfo(isDark, textColor, cardColor),
      ],
    );
  }

  Widget _buildLocationCard(
    bool isDark,
    Color textColor,
    Color? cardColor,
    double distance,
  ) {
    final location = userLocationController.locationData.value;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MyAppColors.primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: MyAppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Location",
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${location?.latitude.toStringAsFixed(4) ?? '--'}, ${location?.longitude.toStringAsFixed(4) ?? '--'}",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Distance to Kaaba",
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                Text(
                  "${distance.toStringAsFixed(0)} km",
                  style: TextStyle(
                    color: MyAppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass(bool isDark, Color textColor) {
    final qiblaDirection = rotationController.qbaRotation.value!;
    final compassHeading = rotationController.compassRotation.value!;
    final needleAngle = _getAngleDifference(qiblaDirection, compassHeading);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: 320,
        height: 320,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Compass Background with Rotation
            Transform.rotate(
              angle: -compassHeading * (math.pi / 180),
              child: CustomPaint(
                size: const Size(320, 320),
                painter: CompassPainter(
                  isDark: isDark,
                  primaryColor: MyAppColors.primaryColor,
                ),
              ),
            ),

            // Qibla Direction Indicator (rotates with compass background)
            Transform.rotate(
              angle: (qiblaDirection - compassHeading) * (math.pi / 180),
              child: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MyAppColors.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                MyAppColors.primaryColor.withValues(alpha: 0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mosque,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 4,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            MyAppColors.primaryColor,
                            MyAppColors.primaryColor.withValues(alpha: 0.0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center Info
            Container(
              padding: const EdgeInsets.all(20),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${needleAngle.abs().toStringAsFixed(0)}°",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _isAligned ? MyAppColors.primaryColor : textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isAligned ? "Aligned" : "to Qibla",
                    style: TextStyle(
                      fontSize: 12,
                      color: _isAligned
                          ? MyAppColors.primaryColor
                          : textColor.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInfo(bool isDark, Color textColor, Color? cardColor) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.explore,
                    size: 18,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Move your phone in a figure 8 pattern to calibrate",
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: _isAligned
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: MyAppColors.primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: MyAppColors.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "You are facing Qibla direction",
                        style: TextStyle(
                          color: MyAppColors.primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        ),
        const Gap(10),
      ],
    );
  }
}

class CompassPainter extends CustomPainter {
  final bool isDark;
  final Color primaryColor;

  CompassPainter({
    required this.isDark,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer ring with gradient
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.1),
          primaryColor.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.7, 0.85, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, gradientPaint);

    // Outer circle border
    final borderPaint = Paint()
      ..color = isDark ? Colors.grey[800]! : Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius - 10, borderPaint);

    // Draw degree markers
    for (int i = 0; i < 360; i += 10) {
      final angle = i * (math.pi / 180);
      final isMajor = i % 30 == 0;

      final startRadius = radius - (isMajor ? 25 : 15);
      final endRadius = radius - 10;

      final start = Offset(
        center.dx + startRadius * math.cos(angle - math.pi / 2),
        center.dy + startRadius * math.sin(angle - math.pi / 2),
      );

      final end = Offset(
        center.dx + endRadius * math.cos(angle - math.pi / 2),
        center.dy + endRadius * math.sin(angle - math.pi / 2),
      );

      final markerPaint = Paint()
        ..color = isMajor
            ? (isDark ? Colors.white70 : Colors.black54)
            : (isDark ? Colors.grey[700]! : Colors.grey[400]!)
        ..strokeWidth = isMajor ? 2 : 1;

      canvas.drawLine(start, end, markerPaint);
    }

    // Draw cardinal directions
    final directions = ["N", "E", "S", "W"];
    final angles = [0, 90, 180, 270];

    for (int i = 0; i < directions.length; i++) {
      final angle = angles[i] * (math.pi / 180);
      final textRadius = radius - 50;

      final textPainter = TextPainter(
        text: TextSpan(
          text: directions[i],
          style: TextStyle(
            color: i == 0
                ? primaryColor
                : (isDark ? Colors.white : Colors.black87),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final offset = Offset(
        center.dx +
            textRadius * math.cos(angle - math.pi / 2) -
            textPainter.width / 2,
        center.dy +
            textRadius * math.sin(angle - math.pi / 2) -
            textPainter.height / 2,
      );

      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

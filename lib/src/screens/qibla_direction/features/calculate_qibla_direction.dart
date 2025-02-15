import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' show radians;

class QiblaCalculator {
  static const double kaabaLatitude = 21.4225; // Kaaba latitude in degrees
  static const double kaabaLongitude = 39.8262; // Kaaba longitude in degrees

  double getQiblaDirection(double latitude, double longitude) {
    double kaabaLatRad = radians(kaabaLatitude);
    double kaabaLongRad = radians(kaabaLongitude);
    double userLatRad = radians(latitude);
    double userLongRad = radians(longitude);

    double longitudeDifference = kaabaLongRad - userLongRad;

    double y = math.sin(longitudeDifference) * math.cos(kaabaLatRad);
    double x =
        math.cos(userLatRad) * math.sin(kaabaLatRad) -
        math.sin(userLatRad) *
            math.cos(kaabaLatRad) *
            math.cos(longitudeDifference);

    double bearingRadians = math.atan2(y, x);
    double bearingDegrees = (bearingRadians * 180 / math.pi);

    // Normalize angle to be in the range [0, 360)
    bearingDegrees = (bearingDegrees + 360) % 360;

    return bearingDegrees;
  }
}

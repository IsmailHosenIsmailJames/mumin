import 'package:flutter_compass/flutter_compass.dart';

class CompassService {
  Stream<CompassEvent> getCompassStream() {
    return FlutterCompass.events!; // Returns a stream of compass events
  }
}

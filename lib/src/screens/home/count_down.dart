import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

import "package:mumin/src/theme/colors.dart";

class RamadanCountdown extends StatefulWidget {
  final TimeOfDay? iftarTime;
  final TimeOfDay? sehriTime;

  const RamadanCountdown({super.key, this.iftarTime, this.sehriTime});

  @override
  State<RamadanCountdown> createState() => _RamadanCountdownState();
}

class _RamadanCountdownState extends State<RamadanCountdown> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  String _countdownType = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant RamadanCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.iftarTime != oldWidget.iftarTime ||
        widget.sehriTime != oldWidget.sehriTime) {
      _timer?.cancel();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (widget.iftarTime == null || widget.sehriTime == null) {
      setState(() {
        _countdownType = "";
      });
      return;
    }

    _calculateTimeLeft();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final nextSehri = _nextInstanceOfTimeOfDay(widget.sehriTime!);
    final nextIftar = _nextInstanceOfTimeOfDay(widget.iftarTime!);

    Duration diffSehri = nextSehri.difference(now);
    Duration diffIftar = nextIftar.difference(now);

    if (diffSehri.inSeconds <= 0 && diffIftar.inSeconds <= 0) {
      _startTimer();
      return;
    }

    if (diffSehri < diffIftar) {
      _countdownType = "Sehri";
      _timeLeft = diffSehri;
    } else {
      _countdownType = "Iftar";
      _timeLeft = diffIftar;
    }
    if (_timeLeft.isNegative) {}

    setState(() {});
  }

  DateTime _nextInstanceOfTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    DateTime nextInstance = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (nextInstance.isBefore(now)) {
      nextInstance = nextInstance.add(const Duration(days: 1));
    }
    return nextInstance;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_countdownType.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        width: 100,
      ).animate(onPlay: (controller) => controller.repeat()).shimmer(
            duration: 1200.ms,
            color: const Color(0xFF80DDFF),
          );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _countdownType,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MyAppColors.secondaryColor,
          ),
        ),
        const Text(
          "Time left:",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          _formatDuration(_timeLeft),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

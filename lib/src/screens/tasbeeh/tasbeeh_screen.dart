import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:mumin/src/theme/colors.dart";
import "package:vibration/vibration.dart";

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _target = 33;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  int _selectedDhikrIndex = 0;

  final List<String> _dhikrs = [
    "SubhanAllah",
    "Alhamdulillah",
    "Allahu Akbar",
    "Astaghfirullah",
    "La ilaha illallah",
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        lowerBound: 0.95,
        upperBound: 1.0);
    _scaleAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _incrementCount() async {
    if (_target != 0 && _count >= _target) return; // Stop at target

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 40);
    }
    _animController.forward().then((value) => _animController.reverse());

    setState(() {
      _count++;
    });

    if (_target != 0 && _count == _target) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 150);
      }
      // Optional: Show celebration or dialog
    }
  }

  void _resetCount() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 70);
    }
    setState(() {
      _count = 0;
    });
  }

  void _toggleTarget() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 30);
    }
    setState(() {
      if (_target == 33) {
        _target = 99;
      } else if (_target == 99) {
        _target = 0; // Infinity
      } else {
        _target = 33;
      }
      _count = 0; // Reset count on target change for clarity
    });
  }

  void _changeDhikr(int index) async {
    if (_selectedDhikrIndex == index) return;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 30);
    }
    setState(() {
      _selectedDhikrIndex = index;
      _count = 0; // Optional: Reset count when changing Dhikr
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = MyAppColors.primaryColor;
    final bgColor = isDark ? Colors.black : Colors.grey[50];
    final textColor = isDark ? Colors.white : Colors.black87;

    double progress = _target == 0 ? 0 : _count / _target;
    if (progress > 1.0) progress = 1.0;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Tasbeeh",
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Open settings or history
            },
            icon: Icon(Icons.history, color: textColor),
          ),
        ],
      ),
      body: Column(
        children: [
          // Dhikr Selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dhikrs.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedDhikrIndex == index;
                return GestureDetector(
                  onTap: () => _changeDhikr(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor
                          : (isDark ? Colors.grey[800] : Colors.white),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4))
                            ]
                          : [],
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                ? Colors.grey[700]!
                                : Colors.grey.shade300),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _dhikrs[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : Colors.grey[700]),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: _incrementCount,
              behavior: HitTestBehavior.opaque,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Full screen tap area visual feedback (optional ripple could go here)

                  // Progress Ring
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background Ring
                          SizedBox(
                            width: 280,
                            height: 280,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 20,
                              color: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey.shade200,
                            ),
                          ),
                          // Active Progress Ring
                          SizedBox(
                            width: 280,
                            height: 280,
                            child: _target == 0
                                ? null
                                : CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 20,
                                    strokeCap: StrokeCap.round,
                                    color: primaryColor,
                                    backgroundColor: Colors.transparent,
                                  ),
                          ),
                          // Count Text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$_count",
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  height: 1.0,
                                ),
                              ),
                              if (_target != 0)
                                Text(
                                  "/ $_target",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              else
                                const Icon(Icons.all_inclusive,
                                    size: 30, color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Hint Text
                  Positioned(
                    bottom: 40,
                    child: Text(
                      "Tap anywhere to count",
                      style: TextStyle(
                        color: Colors.grey.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildControlButton(
                  icon: Icons.refresh,
                  label: "Reset",
                  onTap: _resetCount,
                  isDark: isDark,
                ),
                _buildControlButton(
                  icon:
                      _target == 0 ? Icons.all_inclusive : Icons.track_changes,
                  label: _target == 0 ? "Infinity" : "Target: $_target",
                  onTap: _toggleTarget,
                  isDark: isDark,
                  isWide: true,
                ),
                // Placeholder for sound/vibrate toggle if needed
                _buildControlButton(
                  icon: Icons.vibration,
                  label: "Haptics", // Could be a toggle state
                  onTap: () {
                    HapticFeedback.lightImpact(); // Just demo
                  },
                  isDark: isDark,
                  isActive: true, // Show as active
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    bool isWide = false,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isWide ? 16 : 14),
            decoration: BoxDecoration(
              color: isActive
                  ? MyAppColors.primaryColor.withValues(alpha: 0.15)
                  : (isDark ? Colors.grey[800] : Colors.white),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isActive
                    ? MyAppColors.primaryColor
                    : (isDark ? Colors.grey[700]! : Colors.grey.shade200),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? MyAppColors.primaryColor
                  : (isDark ? Colors.white70 : Colors.grey[700]),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? MyAppColors.primaryColor
                  : (isDark ? Colors.white54 : Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mumin/src/screens/auth/controller/auth_controller.dart";
import "package:mumin/src/theme/colors.dart";
import "package:url_launcher/url_launcher.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  final AuthController authController = Get.put(AuthController());

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final String mobile = _phoneController.text.trim();
    if (mobile.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter phone number");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final bool isSuccessful =
          await authController.login(phone: mobile, isGuest: false);
      if (isSuccessful) {
        if (mounted) context.go("/home");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    try {
      final bool isSuccessful =
          await authController.login(phone: "Guest User", isGuest: true);
      if (isSuccessful) {
        if (mounted) context.go("/home");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Overlay
          Positioned.fill(
            child: Image.asset(
              "assets/images/Splash.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.7)
                  : Colors.black.withValues(alpha: 0.3),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Animate(
                      effects: const [
                        FadeEffect(duration: Duration(milliseconds: 800)),
                        MoveEffect(
                            begin: Offset(0, -20),
                            duration: Duration(milliseconds: 800))
                      ],
                      child: Image.asset(
                        "assets/images/mumin_logo.png",
                        width: 140,
                        height: 140,
                      ),
                    ),
                    const Gap(32),

                    // Glassmorphism Container
                    Animate(
                      effects: const [
                        FadeEffect(
                            delay: Duration(milliseconds: 200),
                            duration: Duration(milliseconds: 800)),
                        ScaleEffect(
                            begin: Offset(0.95, 0.95),
                            duration: Duration(milliseconds: 800))
                      ],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Welcome Back",
                                  style: GoogleFonts.outfit(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Gap(8),
                                Text(
                                  "Log in to continue your journey",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Gap(32),

                                // Phone Input
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      color:
                                          isDark ? Colors.white : Colors.black),
                                  decoration: InputDecoration(
                                    labelText: "Phone Number",
                                    prefixIcon: Icon(
                                        Icons.phone_android_rounded,
                                        color: MyAppColors.primaryColor),
                                    labelStyle: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                    filled: true,
                                    fillColor: isDark
                                        ? Colors.black26
                                        : Colors.white.withValues(alpha: 0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: isDark
                                              ? Colors.white10
                                              : Colors.black12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: MyAppColors.primaryColor),
                                    ),
                                  ),
                                ),
                                const Gap(24),

                                // Login Button
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyAppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : Text(
                                          "Login",
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                                const Gap(20),
                                const Center(
                                  child: Text("Don't have an account? "),
                                ),
                                const Gap(10),
                                // Register Button
                                ElevatedButton(
                                  onPressed: () => context.go("/registration"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyAppColors.secondaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    "Register Now",
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Gap(16),
                                const Center(child: Text("Or")),

                                // Guest Button
                                TextButton(
                                  onPressed:
                                      _isLoading ? null : _handleGuestLogin,
                                  child: Text(
                                    "Continue as Guest",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: MyAppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(24),

                    // Navigation to Register
                    Animate(
                      effects: const [
                        FadeEffect(
                            delay: Duration(milliseconds: 400),
                            duration: Duration(milliseconds: 800))
                      ],
                      child: Column(
                        children: [
                          const Gap(0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildFooterLink(
                                "Privacy Policy",
                                "https://mumin.exiummups.com/privacy",
                                isDark,
                              ),
                              Text(
                                " • ",
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.white60),
                              ),
                              _buildFooterLink(
                                "Support",
                                "https://mumin.exiummups.com/support",
                                isDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String label, String url, bool isDark) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: isDark ? Colors.white38 : Colors.white70,
          decoration: TextDecoration.underline,
          decorationColor: isDark ? Colors.white38 : Colors.white70,
        ),
      ),
    );
  }
}

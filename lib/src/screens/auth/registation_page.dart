import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mumin/src/screens/auth/controller/auth_controller.dart";
import "package:mumin/src/theme/colors.dart";
import "package:url_launcher/url_launcher.dart";

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _pin = TextEditingController();
  bool _isLoading = false;

  final AuthController authController = Get.find();

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final res = await authController.registration(
            context, _name.text.trim(), _mobile.text.trim(), _pin.text.trim());
        if (res) {
          if (mounted) context.go("/home");
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
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
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const Gap(24),

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
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Create Account",
                                    style: GoogleFonts.outfit(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Gap(8),
                                  Text(
                                    "Join us on your path to mindfulness",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Gap(24),

                                  // Name Input
                                  _buildTextField(
                                    controller: _name,
                                    label: "Full Name",
                                    hint: "Enter your name",
                                    icon: Icons.person_outline_rounded,
                                    isDark: isDark,
                                    validator: (value) => value!.isEmpty
                                        ? "Please enter your name"
                                        : null,
                                  ),
                                  const Gap(16),

                                  // Mobile Input
                                  _buildTextField(
                                    controller: _mobile,
                                    label: "Mobile Number",
                                    hint: "Enter your mobile number",
                                    icon: Icons.phone_android_rounded,
                                    keyboardType: TextInputType.phone,
                                    isDark: isDark,
                                    validator: (value) => value!.isEmpty
                                        ? "Please enter your mobile"
                                        : null,
                                  ),
                                  const Gap(16),

                                  // Territory Code Input
                                  _buildTextField(
                                    controller: _pin,
                                    label: "Territory Code",
                                    hint: "Enter your code",
                                    icon: Icons.pin_drop_outlined,
                                    keyboardType: TextInputType.number,
                                    isDark: isDark,
                                    validator: (value) => value!.isEmpty
                                        ? "Please enter your code"
                                        : null,
                                  ),
                                  const Gap(24),

                                  // Sign Up Button
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _register,
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
                                            "Sign Up",
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(24),

                    // Navigation to Login
                    Animate(
                      effects: const [
                        FadeEffect(
                            delay: Duration(milliseconds: 400),
                            duration: Duration(milliseconds: 800))
                      ],
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already Registered?",
                                style: GoogleFonts.inter(
                                  color: isDark ? Colors.white70 : Colors.white,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.go("/login"),
                                child: Text(
                                  "Login Now",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: MyAppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
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
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38, fontSize: 13),
        prefixIcon: Icon(icon, color: MyAppColors.primaryColor),
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        filled: true,
        fillColor:
            isDark ? Colors.black26 : Colors.white.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: MyAppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}

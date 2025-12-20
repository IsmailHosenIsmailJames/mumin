import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:mumin/src/screens/settings/controller/settings_controller.dart";

class QuranSettingsScreen extends StatefulWidget {
  const QuranSettingsScreen({super.key});

  @override
  State<QuranSettingsScreen> createState() => _QuranSettingsScreenState();
}

class _QuranSettingsScreenState extends State<QuranSettingsScreen> {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quran Settings"),
      ),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                "Arabic Font Size",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Slider(
                value: settingsController.arabicFontSize.value,
                min: 18.0,
                max: 50.0,
                onChanged: (value) {
                  settingsController.arabicFontSize.value = value;
                },
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                  style: TextStyle(
                    fontSize: settingsController.arabicFontSize.value,
                    fontFamily: "IndopakNastaleeq",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Translation Font Size",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Slider(
                value: settingsController.translationFontSize.value,
                min: 12.0,
                max: 30.0,
                onChanged: (value) {
                  settingsController.translationFontSize.value = value;
                },
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "In the name of Allah, the Most Gracious, the Most Merciful.",
                  style: TextStyle(
                    fontSize: settingsController.translationFontSize.value,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "English/Bangla Font Size",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Slider(
                value: settingsController.englishFontSize.value,
                min: 12.0,
                max: 30.0,
                onChanged: (value) {
                  settingsController.englishFontSize.value = value;
                },
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "Sample Text for other contents.",
                  style: TextStyle(
                    fontSize: settingsController.englishFontSize.value,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
    );
  }
}

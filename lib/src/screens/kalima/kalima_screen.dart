import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:mumin/src/screens/settings/controller/settings_controller.dart";

class KalimaScreen extends StatelessWidget {
  final Function()? navigation;

  const KalimaScreen({super.key, this.navigation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kalima",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildKalimaCard(
              "1. কালেমা তাইয়্যেবাঃ",
              "لَا اِلَهَ اِلاَّ اللهُ مُحَمَّدُ رَّسُوْ لُ الله",
              "লা-ইলাহা ইল্লাল্লাহু মুহাম্মাদুর রাসূলুল্লাহ",
              "আল্লাহ ভিন্ন ইবাদত বন্দেগীর উপযুক্ত আর কেহই নাই। হযরত মুহাম্মদ ছাল্লাল্লাহু আলাইহি ওয়াছাল্লাম তাঁহার প্রেরিত রসূল।",
              "There is none worthy of worship besides Allah, Muhammad [sallallaahu alayhi wasallam] is the messenger of Allah.",
            ),
            _buildKalimaCard(
              "2. কালেমা শাহাদাতঃ",
              "اَشْهَدُ اَنْ لَّا اِلَهَ اِلَّا اللهُ وَحْدَهُ لَاشَرِيْكَ لَهُ وَاَشْهَدُ اَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُه",
              "আশহাদু আল লা-ইলাহা ইল্লাল্লাহু ওহদাহু লা-শারীকালাহু ওয়াশহাদু আন্না মুহাম্মাদান আবদুহু ওয়া রাছুলুহু ।",
              "আমি সাক্ষ্য দিতেছি যে , অল্লাহ ভিন্ন আর কেহই ইবাদতের উপযুক্ত নাই তিনি এক তাঁহার কোন অংশীদার নাই । আমি আরও সাক্ষ্য দিতেছি যে, হযরত মুহাম্মদ (সাল্লাহু আলাইহে ওয়া সাল্লাম) আল্লাহর শ্রেষ্ঠ বান্দা এবং তাঁহার প্রেরিত নবী।",
              "I bear witness that there is none worthy of worship besides Allah. He is alone. He has no partner, and I bear witness that Muhammad is His servant and messenger.",
            ),
            _buildKalimaCard(
              "3. কালিমা তাওহীদ :",
              "لا الهَ اِلَّا اللّهُ وَحْدَهُ لا شَرِيْكَ لَهْ، لَهُ الْمُلْكُ وَ لَهُ الْحَمْدُ يُحْى وَ يُمِيْتُ وَ هُوَحَىُّ لَّا يَمُوْتُ اَبَدًا اَبَدًا ط ذُو الْجَلَالِ وَ الْاِكْرَامِ ط بِيَدِهِ الْخَيْرُ ط وَهُوَ عَلى كُلِّ شَئ ٍ قَدِيْرٌ ط",
              "লা-ইলাহা ইল্লাল্লাহু ওয়াহ্ দাহু লা-সারিকা লা-হু লাহুল মুলকু ওয়া লাহুল হামদু ইউহা ই ওয়া উ মিতু বি ইয়া সি হিল খাইরু ওয়া-হু-ওয়া আ-লা কুল্লি শাইয়িন ক্বাদীর।",
              "আল্লাহ এক আর কোন মাবুদ নেই তিনি এক তার কোন অংশীদার নেই। সমস্ত সৃষ্টি জগৎ এবং সকল প্রশংসা তাঁরই। তিনি জীবন হান করেন আবার তিনিই মৃত্যুর কারণ তার হাতেই সব ভাল কিছু এবং তিনিই সৃষ্টির সবকিছুর উপর ক্ষমতাবান।",
              "There is none worthy of worship besides Allah who is alone. He has no partner. For him is the Kingdom, and for Him is all praise. He gives life and causes death. In His hand is all good. And He has power over everything.",
            ),
            _buildKalimaCard(
              "4. কালেমা-ই তামজীদঃ",
              "لَا اِلَهَ اِلَّا اَنْتَ نُوْرَ يَّهْدِىَ اللهُ لِنُوْرِهِ مَنْ يَّشَاءُ مُحَمَّدُ رَّسَوْ لُ اللهِ اِمَامُ الْمُرْسَلِيْنَ خَا تَمُ النَّبِيِّنَ",
              "কালেমা–ই তামজীদ বাংলা উচ্চারনঃ লা-ইলাহা ইল্লা আনতা নুরাইইয়াহ দিয়াল্লাহু লিনুরিহী মাইয়্যাশাউ মুহাম্মাদুর রাসূলুল্লাহি ইমামূল মুরছালীনা খাতামুন-নাবিয়্যীন।",
              "হে আল্লাহ ! তুমি ব্যতীত কেহই উপাস্য নাই, তুমি জ্যোতিময় । তুমি যাহাকে ইচ্ছা আপন জ্যোতিঃ প্রদর্শন কর । মুহাম্মদ (সাল্লাল্লাহু আলাইহে ওয়া সাল্লাম) প্রেরিত পয়গম্বরগণের ইমাম এবং শেষ নবী।",
              "Glory be to Allah. All praise be to Allah. There is none worthy of worship besides Allah and Allah is the Gratest. There is no power and might except from Allah, the Most High, the Great.",
            ),
            _buildKalimaCard(
              "5. কালিমায়ে রদ্দে কুফর :",
              "اللهم انی اعوذبک من ان یشرک بک شیئا واستغفرک ما اعلم به ومالا اعلم به تبت عنه وتبرأت من الکفر والشرک والمعاصی کلها واسلمت وامنت واقول ان لا اله الا الله محمد رسول الله صلی الله علیه وسلم",
              "আল্লাহুম্মাহ ইন্নী আউযুবিকা মিন্ আন্ উশ্রিকা বিকা শাইআওঁ ওয়া আনা আ’লামু বিহী, ওয়া আস্তাগ্ফিরুকা লিমা আ’লামু বিহী, ওয়ামা লা-আ’লামু বিহী, তুব্তু আন্হু ওয়া তাবাররা’তু মিনাল কুফরি ওয়াশ্ শিরকি ওয়াল মায়াছী কুল্লিহা, ওয়া আসলামতু ওয়া আমান্তু ওয়া আক্বুলু আল্লা ইলাহা ইল্লাল্লাহু মুহাম্মাদুর রাসুলুল্লাহি।",
              "হে আল্লাহ্! আমি তমার নিকট আকাঙ্ক্ষা করছি যে আমি যেন কাউকে তমার সাথে শরিক না করি। আমি আমার জ্ঞাত ও অজ্ঞাত পাপ হতে ক্ষমা প্রার্থনা করছি এবং তা হতে তওবা করছি। কুফরী, শিরক ও অন্যান্য সব পাপ হতে দূরে থাকছি। এবং স্বীকার করছি যে, “আল্লাহ এক আর কোন মাবুদ নেই। হযরত মুহাম্মদ (সঃ) আল্লাহর প্রেরিত রাসূল।",
              "O Allah, surely I do seek refuge in You from knowingly associating any partner with You, I beg Your forgiveness for the sin from which I am not aware of, I repent it and I declare myself free from infidelity, polytheism (associating any partner with Allah), telling lies and all other sins. I accept Islam and believe and declare that there is none worthy of worship besides Allah and Muhammad [sallallaahu alayhi wasallam] is the messenger of Allah.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKalimaCard(
    String title,
    String arabicText,
    String transliteration,
    String banglaTranslation,
    String englishTranslation,
  ) {
    SettingsController settingsController = Get.put(SettingsController());
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 10),
                Text(
                  arabicText,
                  style: TextStyle(
                    fontSize: settingsController.arabicFontSize.value,
                    fontFamily: "IndopakNastaleeq",
                  ),
                ),
                const Divider(),
                Text(
                  transliteration,
                  style: TextStyle(
                      fontSize: settingsController.translationFontSize.value,
                      fontWeight: FontWeight.w400),
                ),
                const Divider(),
                Text(
                  banglaTranslation,
                  style: TextStyle(
                      fontSize: settingsController.translationFontSize.value,
                      fontWeight: FontWeight.w400),
                ),
                const Divider(),
                Text(
                  englishTranslation,
                  style: TextStyle(
                      fontSize: settingsController.englishFontSize.value,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )),
      ),
    );
  }
}

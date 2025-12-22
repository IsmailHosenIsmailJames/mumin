import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:get/get.dart";
import "package:mumin/src/screens/about/about_page.dart";
import "package:mumin/src/screens/auth/controller/auth_controller.dart";
import "package:mumin/src/screens/auth/login_page.dart";
import "package:mumin/src/screens/auth/registation_page.dart";
import "package:mumin/src/screens/daily_plan/daily_ramadan_plan.dart";
import "package:mumin/src/screens/hadith/hadith_page.dart";
import "package:mumin/src/screens/hadith/parts_view.dart";
import "package:mumin/src/screens/hadith/pdf_view.dart";
import "package:mumin/src/screens/hajj/hajj_page.dart";
import "package:mumin/src/screens/home/home_page.dart";
import "package:mumin/src/screens/kalima/kalima_screen.dart";
import "package:mumin/src/screens/mosque_view/mosque_view.dart";
import "package:mumin/src/screens/prayer_time/prayer_time.dart";
import "package:mumin/src/screens/qibla_direction/qibla_compass_screen.dart";
import "package:mumin/src/screens/quran/resources/model/quran_surah_info_model.dart";
import "package:mumin/src/screens/quran/surah_list_screen.dart";
import "package:mumin/src/screens/quran/surah_view/surah_view.dart";
import "package:mumin/src/screens/ramadan_calender/ramadan_calender_page.dart";
import "package:mumin/src/screens/settings/quran_settings_screen.dart";
import "package:mumin/src/screens/tasbeeh/tasbeeh_screen.dart";
import "package:mumin/src/screens/zakkat/zakkat_screen.dart";

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation:
          Get.find<AuthController>().user.value == null ? "/login" : "/home",
      routes: [
        GoRoute(
          path: "/home",
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: "/about",
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: "/hajj",
          builder: (context, state) => const HajjPage(),
        ),
        GoRoute(
          path: "/kalima",
          builder: (context, state) => const KalimaScreen(),
        ),
        GoRoute(
          path: "/mosque",
          builder: (context, state) => const MosqueScreen(),
        ),
        GoRoute(
          path: "/tasbeeh",
          builder: (context, state) => const TasbeehScreen(),
        ),
        GoRoute(
          path: "/zakat_screen",
          builder: (context, state) => const ZakatScreen(),
        ),
        GoRoute(
          path: "/login",
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: "/registration",
          builder: (context, state) => const RegistrationScreen(),
        ),
        GoRoute(
          path: "/quran",
          builder: (context, state) => const SurahListScreen(),
        ),
        GoRoute(
          path: "/read_practice",
          builder: (context, state) =>
              const SurahListScreen(practiceMode: true),
        ),
        GoRoute(
          path: "/hadith",
          builder: (context, state) => const HadithPage(),
        ),
        GoRoute(
          path: "/qibla_direction",
          builder: (context, state) => const QiblaCompassScreen(),
        ),
        GoRoute(
          path: "/prayer_time",
          builder: (context, state) => const PrayerTime(),
        ),
        GoRoute(
          path: "/ramadan_calender",
          builder: (context, state) => const RamadanCalenderPage(),
        ),
        GoRoute(
          path: "/surah_view",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return SurahView(
              surahIndex: extra["surahIndex"],
              surahName: extra["surahName"],
              quranInfoModel:
                  QuranSurahInfoModel.fromMap(extra["quranInfoModel"]),
              practiceMode: extra["practiceMode"],
              startAt: extra["startAt"],
              start: extra["start"],
              end: extra["end"],
            );
          },
        ),
        GoRoute(
          path: "/daily_ramadan_plan",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return DailyRamadanPlan(day: extra["day"]);
          },
        ),
        GoRoute(
          path: "/hadith_parts",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return PartsView(
              id: extra["id"],
              hadithName: extra["hadithName"],
            );
          },
        ),
        GoRoute(
          path: "/hadith_pdf",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return HadithPdfView(
              url: extra["url"],
              title: extra["title"],
            );
          },
        ),
        GoRoute(
          path: "/settings",
          builder: (context, state) => const QuranSettingsScreen(),
        ),
      ],
      redirect: (context, state) {
        // Basic redirection logic if needed, but for now we rely on initialLocation
        // and manual navigation.
        return null;
      });
}

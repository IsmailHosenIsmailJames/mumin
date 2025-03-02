# Mumin - Your Comprehensive Islamic Companion App

**Developed by: MD. Ismail Hosen James for Exium, Radiant Pharmaceuticals Limited**

Mumin is a comprehensive Islamic mobile application designed to assist Muslims in their daily religious practices, particularly during the holy month of Ramadan.  The app provides a range of features, from prayer time calculations and Qibla direction to Quran recitation, Hadith, and a Ramadan calendar.  It is built with a user-friendly interface and includes features for both daily use and special occasions like Hajj.

## Key Features:

The screenshots and commit history show a very well-developed and feature-rich application.  This `readme.md` reflects that.

*   **Ramadan Central:**
    *   **Ramadan Calendar:**  A full Ramadan calendar with accurate Sehri (pre-dawn meal) and Iftar (meal to break the fast) times, specific to the user's location (Tangail District, Dhaka Division, Bangladesh, as shown in the screenshot, but adaptable).  The calendar displays the date, Sehri end time, and Iftar time for each day of Ramadan (starting March 2, 2025, in the example).
    *   **Sehri and Iftar Countdown:**  A prominent countdown timer showing the time remaining until the next Iftar.  This is a crucial feature for those fasting.
    *   **Daily Ramadan Plan (Dua, Quran, Hadith):**  Provides curated content for each day of Ramadan, including specific Duas (supplications) with both Arabic text and English translations, relevant Quranic verses, and Hadith.  This is a *major* feature that adds significant value.
    *   **30-Day Ramadan Plan:** A structured plan covering the entire month of Ramadan, likely with additional content or guidance.

*   **Prayer Essentials:**
    *   **Prayer Times:**  Calculates accurate prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha) based on the user's location.  The screenshot shows the "Next prayer" prominently displayed.
    *   **Qibla Compass:**  An integrated Qibla compass that visually indicates the direction of the Kaaba in Mecca, essential for prayer.  The compass uses a clear, easy-to-understand visual representation.
    *   **Mosque Finder:**  Integrates with a map service (likely Google Maps) to display nearby mosques. This feature utilizes a web view to show mosque locations.

*   **Quran and Hadith:**
    *   **Holy Quran:**  A complete digital Quran with:
        *   Surah List:  A list of all Surahs (chapters) of the Quran, with their names in both English and Arabic, and the number of Ayahs (verses) in each.
        *   Surah View:  Displays individual Surahs with Arabic text, transliteration (using Google Fonts for clear rendering), and translation (in both Bengali and English, based on the screenshots).
        *   Audio Recitation (Implied): The presence of play buttons in the Surah view suggests audio playback functionality.
        *Record Audio: Record the audio and play.
        *   Read & Practice: It sounds like the app has text-to-speech features.
    *   **Hadith:**  Includes a collection of Hadith, likely categorized or searchable.  The screenshots suggest a PDF viewer for Hadith, indicating a well-organized presentation.

*   **Other Islamic Tools:**
    *   **Kalima:**  Displays the six Kalimas (declarations of faith) in Islam.
    *   **Tasbeeh:**  A digital Tasbeeh (prayer beads) counter for Dhikr (remembrance of Allah).
    *   **Zakat Calculator:**  A tool to help calculate Zakat (obligatory charity).
    *   **Hajj Guide:**  Provides information and guidance related to the Hajj pilgrimage.
    *   **About Page:**  Contains information about the app and its developers.

## Technical Details & Development History:

The commit history provides excellent insight into the development process:

*   **Technology:**  The app is likely built using a cross-platform framework (given the removal of web, macOS, Linux, and Windows support), most probably Flutter, based on the file structure and common practices.
*   **Development Process:**  The commits show a clear, iterative development approach, with frequent updates and bug fixes.  The developer focused on:
    *   **UI/UX:**  Multiple commits related to UI enhancement and bug fixes, showing a commitment to a polished user experience.  Dynamic theme support is also included.
    *   **Core Functionality:**  Progressive implementation of features, starting with basic components and gradually adding more complex ones.
    *   **API Integration:**  Use of APIs for prayer times, in-app updates, and potentially other features.
    *   **Performance:**  Optimization efforts, such as removing unnecessary platform support and using a single release build.
    *   **Notifications:** Implementation of scheduled notifications (likely for prayer times and Sehri/Iftar reminders).  Foreground services were initially used but later replaced with scheduled notifications, which is a best practice for battery life.
    *   **Permissions:** Handling of location and notification permissions.
    *   **In-App Updates:**  The app includes a mechanism for in-app updates, allowing for easy distribution of new features and bug fixes.
* **Date and Times:** App shows Correct date and times according to location.

## Future Enhancements (Suggestions):

Based on the existing features and commit history, here are some potential future enhancements:

*   **Audio Quran Recitation (Confirmation):**  If not already fully implemented, ensure high-quality audio recitation for all Surahs.
*   **Advanced Search:**  Implement search functionality within the Quran and Hadith sections.
*   **Multiple Languages:**  Expand language support beyond English and Bengali.
*   **Customization:**  Allow users to customize the app's appearance (themes, font sizes).
*   **Community Features:**  Consider adding features like a forum or social sharing (while maintaining religious sensitivity).
*   **Offline Access:**  Allow users to download Quran and Hadith content for offline access.
*   **More detailed Mosque Information:**  Provide more information about mosques in the Mosque Finder, such as prayer times, contact information, and facilities.

## Conclusion:

Mumin is a well-designed and comprehensive Islamic app that provides significant value to its users. The clear development process, focus on user experience, and inclusion of essential features make it a valuable tool for Muslims seeking to enhance their religious practice. The detailed Ramadan features are particularly strong, making it an excellent companion for the holy month. The app demonstrates a strong commitment to providing accurate information and a user-friendly experience.

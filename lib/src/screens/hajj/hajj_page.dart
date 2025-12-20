import "package:flutter/material.dart";
import "package:mumin/src/theme/colors.dart";
import "package:mumin/src/theme/shapes.dart";

class HajjPage extends StatefulWidget {
  const HajjPage({super.key});

  @override
  State<HajjPage> createState() => _HajjPageState();
}

class _HajjPageState extends State<HajjPage> {
  PageController pageController = PageController();
  int pageNumber = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hajj",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 210,
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {
                    pageNumber = value;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: MyAppShapes.borderRadius,

                      child: Image.asset(
                        "assets/images/hajj.jpg",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: MyAppShapes.borderRadius,
                      child: Image.asset(
                        "assets/images/hajj_3.webp",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: MyAppShapes.borderRadius,
                      child: Image.asset(
                        "assets/images/hajj_2.jpg",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width:
                      pageNumber == 0
                          ? MediaQuery.of(context).size.width * 0.7
                          : 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyAppColors.primaryColor,
                    borderRadius: MyAppShapes.borderRadius,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width:
                      pageNumber == 1
                          ? MediaQuery.of(context).size.width * 0.7
                          : 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyAppColors.primaryColor,
                    borderRadius: MyAppShapes.borderRadius,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width:
                      pageNumber == 2
                          ? MediaQuery.of(context).size.width * 0.7
                          : 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyAppColors.primaryColor,
                    borderRadius: MyAppShapes.borderRadius,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Hajj Is The Fourth Pillar Of Islam",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 15),
            const Text(
              "Hajj Is More Than 1,500 Years Old",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Text(
              "The origins of Hajj actually date much further back than the time of the Prophet Muhammad (peace and blessings be upon him). The rituals of Hajj in fact go back to 2000 BCE!",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "If we think of the rites involved in Hajj: running between Safa and Marwa to replicate Hajar’s (the wife of Ibrahim AS) journey in search of water, then it’s actually a lot older…",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "The Kaaba itself also dates back much earlier than 631CE. The Prophet Ibrahim (AS) built a monument on the site of the Kaaba and worshippers from a variety of faiths used to come and visit the site. Mount Arafah was where Ibrahim (AS) prepared to sacrifice his son.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "In 632CE, Prophet Muhammad (peace and blessings be upon him) then led the first official Hajj, when he led a group of worshippers to the Kaaba in 632CE and destroyed the idols inside the Kaaba, restoring it to its original purpose in the name of Allah (SWT).",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "Prophet Muhammad (peace and blessings be upon him) and the first Muslims retraced Hajar’s journey between the hills of Safa and Marwa. They replicated the stoning of Iblis (Satan), as Prophet Ibrahim (AS) did when Iblis tried to tempt him to defy Allah (SWT) in three separate locations on the journey. Ibrahim (AS) continued in his obedience to Allah (SWT). Mount Arafah was also the location of the Prophet Muhammad’s (peace and blessings be upon) last sermon.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "During his life, Prophet Muhammad (peace and blessings be upon him) only performed Hajj once. Since then, the tradition has been continued by Muslims from across the world for over a millennia of years. Subhan’Allah – such history!",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 15),
            const Text(
              "Hajj Is Always On The 8th – 13th Dhul Hijjah",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Text(
              "Hajj takes place during the month of Dhul Hijjah – which translates to ‘the month of the pilgrimage’.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "In line with the Islamic calendar, Hajj takes places during the same period of the lunar calendar each year. The dates therefore appear to shift forward approximately 11-12 days in the Gregorian calendar each year.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "This year, Dhul Hijjah will run from 7th July to 11th/12th July 2022.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "Dhul Hijjah is a very important month. Not only is it the last month in the Islamic year, but during this period, Muslims make Hajj, offer Qurbani to those in need and celebrate Eid al-Adha before the new year begins.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "The sacred Day of ‘Arafah takes place on 9th Dhul Hijjah, and offers Muslims around the world who are not on Hajj the chance to earn immense reward, by fasting and making sincere du’a. Fasting on the Day of Arafah can expiate your sins of two years!",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 15),
            const Text(
              "Over 2.5 Million Muslims A Year Go On Hajj",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Text(
              "We all know how popular Hajj is, but how many people go each year?",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "In line with the Islamic calendar, Hajj takes places during the same period of the lunar calendar each year. The dates therefore appear to shift forward approximately 11-12 days in the Gregorian calendar each year.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "Well, according to the Saudi government figures for 2019, a staggering 2.5 million undertook Hajj! Subhan’Allah…",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "With around three times as many international pilgrims (1.9 million), compared to Saudi-residents (Saudi and non-Saudi) (634K), you may be intrigued to find out that the highest single nationality of non-Saudi pilgrims was in fact Egyptian!",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 5),
            const Text(
              "Alhamdulillah, pilgrims come from all over the world with most non-Saudi pilgrims travelling from Asian (non-Arab) countries (59%). However, with a whopping 35,355 pilgrims in 2019, the biggest group of non-Saudi nationals is Egyptians, with almost 36% of non-Saudi pilgrims from Egypt.",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 15),
            Text(
              "7 Steps of Hajj – Complete Hajj Guide For Pilgrims",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: MyAppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildStep("Step 1 – Ihram and Intentions", [
              "Making a pure intention and wearing the Ihram are the two of the first essential steps when going for Hajj. After making the niyat, Muslim pilgrims are advised to wear the Ihram- two pieces of unstitched white sheets for men and a loose-fitting Abaya for women, properly covering the whole body. It is recommended that the pilgrim should wear the Ihram on Dhul-Hijjah before entering Miqat – the outer boundaries of Makkah. The five entry points or relevant Miqats for pilgrims are as follows:",
              "1. Abbyar Ali (Dhu’l Hulaifah) – This is the point of Miqat for pilgrims coming through Madina or from Saudi Arabia. They are advised to perform Hajj al-Tamatt’u.",
              "2. (As-Sail Al-Kabeer) Qarn-al Manzil – This is the point of Miqat for pilgrims coming through or from Taif or Najd.",
              "3. Al- Juhfah – Located near Rabigh, it is the point of Miqat for pilgrims coming through or from Egypt, Syria, or Morocco.",
              "4. Dhat’Irq – Is the point of Miqat for pilgrims coming from or through Iraq.",
              "5. Sa’adiyah (Yalamlam) – This is the point of Miqat for pilgrims coming through or from Yemen, India, or Pakistan.",
              "Also, once in Ihram, pilgrims are advised to recite Talbiyah while abstaining from all sinful acts. The Talibyah should be recited in a loud voice:",
              "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، انَّالْحَمْدَ، وَالنِّعْمَةَ، لَكَ وَالْمُلْكَ، لا شَرِيكَ لَكَ",
              "Labbayk Allaahumma labbayk, labbayk laa shareeka laka labbayk, ‘innal-hamda, wanni’mata, laka walmulk, laa shareeka laka.",
            ]),
            _buildStep("Step 2 – Mina aka “City of Tents”", [
              "Situated 5 to 6 km from Makkah, Mina is a small town. Arriving at the tent city of Mina, pilgrims are advised to rest there until the following day. Starting with the noon prayer (Zuhr) and ending with the dawn prayer (Fajr), pilgrims recite all five Salahs while staying in Mina. Today, the land of Mina comprises modern tents that are equipped with all essential amenities. Muslims should recite both compulsory and non-compulsory prayers while staying at Mina.",
            ]),
            _buildStep("Step 3 – Mina to Arafat, 9th Day of Dhul-Hijjah", [
              "On the morning of the second day of Hajj that is 9th Dhul-Hijjah, the pilgrims start walking towards Arafat while reciting Talbiyah at the top of their voices. Muslim pilgrims observe Zuhrain – a combination of Zuhr and Asr prayer with Qasar prayer upon reaching the mount of Arafat. This is known as Waquf – the act of standing before Allah (SWT) and is observed near the Jabal al-Rahmah from noon to sunset.",
            ]),
            _buildStep("Step 4 – Muzdalifah", [
              "The pilgrims’ next destination for Hajj is Muzdalifah, a small town located between Mina and Mount Arafat. Upon arriving at sunset on the grounds of Muzdalifah, the pilgrims offer Maghribaen – a combined prayer of Maghrib and Isha. Muslims spend one whole night under the open sky and collect 49 pebbles of similar sizes for the ritual of Rami (stoning of the Devil). They then leave the town of Muzdalifah on the morning of 10th Dhul-Hijjah.",
            ]),
            _buildStep("Step 5 – Rami (Stoning the Devil)", [
              "On arriving at Mina, pilgrims perform the act of Rami by stoning the Jamraat al-Aqabah. Seven stones are thrown at the column structure. The stoning of Jamrat is performed in the memory of the act of Prophet Ibrahim (AS) when the devil tried discouraging him from following Allah (SWT) command. In reply, Prophet Ibrahim (AS) threw small pebbles to make the devil go away. Rami should be carried out at noon each day. Rami is performed on the 11th and 12th of Dhul-Hijjah.",
            ]),
            _buildStep("Step 6 – Nahr", [
              "After the completion of Rami, on 12th Dhul-Hijjah, Muslim pilgrims are advised to perform the sacrifice of an animal; it can be a camel or lamb. For this, pilgrims can either purchase sacrifice coupons or vouchers, stating that the sacrifice has been made on their behalf. The meat of the sacrificed animal should be distributed to the needy.",
            ]),
            _buildStep("Step 7 – Farewell Tawaf", [
              "After completing the ritual, pilgrims return to the Holy Kaaba in Makkah to perform the “Tawaf al-Ifadah,” also known as the “Farewell Tawaf,” followed by Sa’I. Though this officially marks the end of Hajj, many pilgrims also visit Madinah before heading home.",
            ]),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildStep(String title, List<String> descriptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        ...descriptions.map(
          (description) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(description, style: const TextStyle(fontSize: 15)),
          ),
        ),
      ],
    );
  }
}

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:mumin/src/theme/colors.dart";
import "package:mumin/src/theme/shapes.dart";

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  TasbeehScreenState createState() => TasbeehScreenState();
}

class TasbeehScreenState extends State<TasbeehScreen> {
  int tasbeehCount = 0;
  int pageNumber = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Tasbeeh",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Calligraphy Section
          Center(
            child: Image.asset(
              "assets/images/calliography.png",
              fit: BoxFit.contain,
            ),
          ),
          const Gap(20),
          SizedBox(
            height: 30,
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  pageNumber = value;
                });
              },
              children: [
                Text(
                  "SubahanAllah",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Allahu Akbar",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Alhamdulillah",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width:
                    pageNumber == 0
                        ? MediaQuery.of(context).size.width * 0.3
                        : 15,
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
                        ? MediaQuery.of(context).size.width * 0.3
                        : 15,
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
                        ? MediaQuery.of(context).size.width * 0.3
                        : 15,
                height: 5,
                decoration: BoxDecoration(
                  color: MyAppColors.primaryColor,
                  borderRadius: MyAppShapes.borderRadius,
                ),
              ),
            ],
          ),
          const Gap(10),

          // Tasbeeh Section
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/calculator_bg.png",
                  fit: BoxFit.contain,
                  height: double.infinity,
                  width: double.infinity,
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          children: <TextSpan>[
                            TextSpan(
                              text: "$tasbeehCount",
                              style: const TextStyle(color: Colors.white),
                            ),
                            const TextSpan(
                              text: "/99",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.blue.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (tasbeehCount > 0) {
                                    tasbeehCount--;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: MyAppColors.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (tasbeehCount < 99) {
                                    tasbeehCount++;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            tasbeehCount = 0;
                          });
                        },
                        icon: const Icon(
                          CupertinoIcons.refresh,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/images/tasbeeh_icon.png",
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}

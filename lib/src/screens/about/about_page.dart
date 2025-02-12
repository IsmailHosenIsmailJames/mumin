import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:mumin/src/theme/shapes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text('This app is developed for'),
                  const Text(
                    'Education Support Program',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  const Text('Courtesy -'),
                  Image.asset(
                    'assets/images/radiant_logo.png',
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Radiant Pharmaceuticals Limited',
                    style: TextStyle(
                      color: MyAppColors.backgroundLightColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                'A renowned healthcare solution provider in Bangladesh by consistently achieving the highest business growth for most of the years since its inception. Radiant is engaged in manufacturing and marketing of medicines for both local and overseas markets. With its focus always on strict adherence to quality standards along with significant investment in the development of a human resource pool, Radiant has distinguished itself as one of the most reliable names in the pharma industry of Bangladesh.',
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                'Radiant has been instrumental at all times in promoting technology transfer through establishing collaboration with the internationally reputed research-based companies. This is reflected by the fact that it is in license agreement with several pharmaceutical companies including F. Hoffmann-La Roche Limited, Switzerland.',
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                'Radiant Pharmaceuticals Limited of tomorrow will provide customers with world class medications for their better health and well-being and it always aims to stand on the forefront of advancement of the healthcare system, turning innovative science into value for patients and it continuously strives to fulfill the expectations of its stakeholders and society in general.',
                textAlign: TextAlign.justify,
              ),
            ),
            const Gap(20),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: MyAppColors.primaryColor,
                borderRadius: MyAppShapes.borderRadius,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Corporate Head Office',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Radiant Pharmaceuticals Limited. SKS Tower (7th Floor & 8th Floor), 7 VIP Road, Mohakhali, Dhaka 1206, Bangladesh.',
                  ),
                  Text(
                    'Tel: +880 2 9835717',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Fax: +880 2 55058522',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: MyAppColors.primaryColor,
                borderRadius: MyAppShapes.borderRadius,
              ),
              width: double.infinity,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Email : info@radiant.com.bd',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'www.radiantpharmabd.com',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

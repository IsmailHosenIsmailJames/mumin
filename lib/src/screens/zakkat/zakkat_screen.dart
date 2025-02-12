import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mumin/src/theme/colors.dart';
import 'package:toastification/toastification.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  ZakatScreenState createState() => ZakatScreenState();
}

class ZakatScreenState extends State<ZakatScreen> {
  double nisab = 43000;
  String? gold;
  String? silver;
  String? cash;
  String? depositHajj;
  String? loan;
  String? savBusipen;
  String? credit;
  String? wagesDue;
  String? taxDue;
  double payable = 0.0;
  bool showAlert = false;
  bool isFormValidated = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Zakat Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              elevation: 3,
              color: MyAppColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nisab : ',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: MyAppColors.backgroundDarkColor,
                          ),
                        ),
                        Text(
                          '$nisab BDT',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: MyAppColors.backgroundDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Nisab (updated 09 April 2020)',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    _buildSection(context, 'Assets', [
                      _buildTextField(
                        context,
                        'Value Of Gold',
                        gold,
                        (text) => gold = text,
                        TextInputType.number,
                      ),
                      _buildTextField(
                        context,
                        'Value Of Silver',
                        silver,
                        (text) => silver = text,
                        TextInputType.number,
                      ),
                      _buildTextField(
                        context,
                        'In hand and in bank accounts',
                        cash,
                        (text) => cash = text,
                        TextInputType.number,
                      ),
                      _buildTextField(
                        context,
                        'Deposited for ( e.g. Hajj )',
                        depositHajj,
                        (text) => depositHajj = text,
                        TextInputType.number,
                      ),
                      _buildTextField(
                        context,
                        'Given out in loans',
                        loan,
                        (text) => loan = text,
                        TextInputType.number,
                      ),
                      _buildTextField(
                        context,
                        'Business investments, shares, saving certificates, pensions',
                        savBusipen,
                        (text) => savBusipen = text,
                        TextInputType.number,
                      ),
                    ]),
                    _buildSection(context, 'Liabilities', [
                      _buildTextField(
                        context,
                        'Borrowed money, goods bought on credit',
                        credit,
                        (text) => credit = text,
                        TextInputType.number,
                      ),
                      _buildTextField(
                        context,
                        'Wages due to employees',
                        wagesDue,
                        (text) => wagesDue = text,
                        TextInputType.number,
                      ),
                      _buildTextField(
                        context,
                        'Taxes, rent, utility bills due immediately',
                        taxDue,
                        (text) => taxDue = text,
                        TextInputType.number,
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyAppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            getTotal(context);
                          },
                          child: Text(
                            'Calculate',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet:
          (payable > 0.0)
              ? Container(
                height: 100,
                decoration: BoxDecoration(
                  color: MyAppColors.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Payable Zakat: $payable BDT',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              : const SizedBox.shrink(),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    String? value,
    Function(String) onChanged,
    TextInputType keyboardType,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyAppColors.backgroundDarkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyAppColors.backgroundDarkColor),
          ),
        ),
        initialValue: value,
        onChanged: onChanged as void Function(String)?,
      ),
    );
  }

  Future<void> getTotal(BuildContext context) async {
    if (gold == null || gold!.isEmpty) {
      toastification.show(
        title: const Text('Gold input is empty'),
        context: context,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topRight,
        type: ToastificationType.error,
      );
      return;
    }
    if (silver == null || silver!.isEmpty) {
      toastification.show(
        title: const Text('Silver input is empty'),
        context: context,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topRight,
        type: ToastificationType.error,
      );
      return;
    }
    if (cash == null || cash!.isEmpty) {
      toastification.show(
        title: const Text('Cash input is empty'),
        context: context,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topRight,
        type: ToastificationType.error,
      );
      return;
    }

    try {
      double asset =
          (double.tryParse(gold ?? '0') ?? 0) +
          (double.tryParse(silver ?? '0') ?? 0) +
          (double.tryParse(cash ?? '0') ?? 0) +
          (double.tryParse(depositHajj ?? '0') ?? 0) +
          (double.tryParse(loan ?? '0') ?? 0) +
          (double.tryParse(savBusipen ?? '0') ?? 0);

      double liabilitiesAmount =
          (double.tryParse(credit ?? '0') ?? 0) +
          (double.tryParse(wagesDue ?? '0') ?? 0) +
          (double.tryParse(taxDue ?? '0') ?? 0);

      double totalAsset = asset - liabilitiesAmount;

      double zakatPayable = 0;
      if (totalAsset >= nisab) {
        zakatPayable = (totalAsset * 2.5) / 100;
      }

      setState(() {
        payable = zakatPayable;
      });
    } catch (e) {
      toastification.show(
        title: Text(e.toString()),
        context: context,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topRight,
      );
    }
  }
}

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:mumin/src/theme/colors.dart";

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  ZakatScreenState createState() => ZakatScreenState();
}

class ZakatScreenState extends State<ZakatScreen> {
  // Config
  double nisab = 55000; // Default baseline, can be edited by user

  // Controllers
  final TextEditingController _nisabController = TextEditingController();

  final TextEditingController _goldController = TextEditingController();
  final TextEditingController _silverController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _depositHajjController = TextEditingController();
  final TextEditingController _loanController = TextEditingController();
  final TextEditingController _savBusipenController = TextEditingController();

  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _wagesDueController = TextEditingController();
  final TextEditingController _taxDueController = TextEditingController();

  // State
  double _totalAssets = 0.0;
  double _totalLiabilities = 0.0;
  double _netAssets = 0.0;
  double _zakatPayable = 0.0;

  @override
  void initState() {
    super.initState();
    _nisabController.text = nisab.toStringAsFixed(0);
    _setupListeners();
    _calculate(); // Initial calc
  }

  void _setupListeners() {
    final controllers = [
      _nisabController,
      _goldController,
      _silverController,
      _cashController,
      _depositHajjController,
      _loanController,
      _savBusipenController,
      _creditController,
      _wagesDueController,
      _taxDueController,
    ];

    for (var controller in controllers) {
      controller.addListener(_calculate);
    }
  }

  @override
  void dispose() {
    _nisabController.dispose();
    _goldController.dispose();
    _silverController.dispose();
    _cashController.dispose();
    _depositHajjController.dispose();
    _loanController.dispose();
    _savBusipenController.dispose();
    _creditController.dispose();
    _wagesDueController.dispose();
    _taxDueController.dispose();
    super.dispose();
  }

  double _parse(String text) {
    if (text.isEmpty) return 0.0;
    // Remove non-numeric characters except dot (e.g. commas)
    String cleaned = text.replaceAll(RegExp(r"[^0-9.]"), "");
    return double.tryParse(cleaned) ?? 0.0;
  }

  void _calculate() {
    double currentNisab = _parse(_nisabController.text);

    double assets = _parse(_goldController.text) +
        _parse(_silverController.text) +
        _parse(_cashController.text) +
        _parse(_depositHajjController.text) +
        _parse(_loanController.text) +
        _parse(_savBusipenController.text);

    double liabilities = _parse(_creditController.text) +
        _parse(_wagesDueController.text) +
        _parse(_taxDueController.text);

    double net = assets - liabilities;
    // Allow net to be negative conceptually, but practically 0 for zakat base
    double zakatBase = net > 0 ? net : 0;

    double payable = 0.0;
    if (zakatBase >= currentNisab) {
      payable = zakatBase * 0.025;
    }

    setState(() {
      nisab = currentNisab;
      _totalAssets = assets;
      _totalLiabilities = liabilities;
      _netAssets = net;
      _zakatPayable = payable;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEligible = _netAssets >= nisab;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? MyAppColors.backgroundDarkColor : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSummaryCard(context, isEligible),
                  const SizedBox(height: 24),
                  _buildNisabSettings(context, isDark),
                  const SizedBox(height: 24),
                  _buildInputSection(
                    context: context,
                    title: "Assets (Gold, Cash, Investments)",
                    icon: Icons.account_balance_wallet_outlined,
                    color: Colors.green.shade700,
                    isDark: isDark,
                    children: [
                      _buildInputField("Gold Value", _goldController, isDark),
                      _buildInputField(
                          "Silver Value", _silverController, isDark),
                      _buildInputField(
                          "Cash in Hand/Bank", _cashController, isDark),
                      _buildInputField(
                          "Hajj Deposit", _depositHajjController, isDark),
                      _buildInputField("Loans Given", _loanController, isDark),
                      _buildInputField(
                          "Business/Shares", _savBusipenController, isDark),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInputSection(
                    context: context,
                    title: "Liabilities (Debts, Bills)",
                    icon: Icons.money_off_outlined,
                    color: Colors.red.shade700,
                    isDark: isDark,
                    children: [
                      _buildInputField(
                          "Borrowed/Debts", _creditController, isDark),
                      _buildInputField(
                          "Wages Due", _wagesDueController, isDark),
                      _buildInputField(
                          "Taxes/Bills Due", _taxDueController, isDark),
                    ],
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: MyAppColors.primaryColor,
      title: const Text(
        "Zakat Calculator",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    );
  }

  Widget _buildSummaryCard(BuildContext context, bool isEligible) {
    return Container(
      decoration: BoxDecoration(
        color: MyAppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MyAppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Net Assets",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${_netAssets.toStringAsFixed(2)} BDT",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isEligible
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isEligible ? Icons.check_circle : Icons.info_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isEligible ? "Eligible" : "Not Eligible",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Assets",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "${_totalAssets.toStringAsFixed(0)} BDT",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Total Liabilities",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "${_totalLiabilities.toStringAsFixed(0)} BDT",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Colors.white24, height: 1),
            ),
            const Text(
              "Total Zakat Payable",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${_zakatPayable.toStringAsFixed(2)} BDT",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNisabSettings(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.amber.shade900.withValues(alpha: 0.3)
                  : Colors.amber.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.settings_outlined,
                color: isDark ? Colors.amber.shade700 : Colors.amber.shade800,
                size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nisab Threshold",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Edit if current rate changes",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _nisabController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyAppColors.primaryColor,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: MyAppColors.primaryColor),
                ),
                suffixText: "৳",
                suffixStyle:
                    TextStyle(color: isDark ? Colors.white70 : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          childrenPadding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          children: children,
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*")),
        ],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey.shade600,
              fontSize: 14),
          prefixIcon: Icon(Icons.attach_money,
              size: 18, color: isDark ? Colors.white54 : Colors.grey.shade400),
          filled: true,
          fillColor: isDark ? Colors.grey[800] : Colors.grey.shade50,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: MyAppColors.primaryColor, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          suffixText: "BDT",
          suffixStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade400,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

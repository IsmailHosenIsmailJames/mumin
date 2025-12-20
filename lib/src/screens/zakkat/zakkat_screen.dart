import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:mumin/src/theme/colors.dart"; // Make sure this import is correct
import "package:toastification/toastification.dart";

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  ZakatScreenState createState() => ZakatScreenState();
}

class ZakatScreenState extends State<ZakatScreen> {
  //  Nisab value, ideally fetched from an API or a configuration file
  double nisab =
      45000; // Example value, update as needed. Consider making it a const if it rarely changes, or fetch dynamically.

  // Use TextEditingController for better control and to avoid potential issues with initialValue
  final TextEditingController _goldController = TextEditingController();
  final TextEditingController _silverController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _depositHajjController = TextEditingController();
  final TextEditingController _loanController = TextEditingController();
  final TextEditingController _savBusipenController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _wagesDueController = TextEditingController();
  final TextEditingController _taxDueController = TextEditingController();

  double payable = 0.0;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Consistent with the modern, flat design
        title: const Text(
          "Zakat Calculator",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyAppColors
            .primaryColor, // Use primary color for a cohesive look, adjust if needed.
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Nisab Information Card
            Card(
              margin: const EdgeInsets.all(16.0),
              // Consistent margins
              elevation: 2,
              // Slightly reduced elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              color: MyAppColors.primaryColor, // Use your app's primary color
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Nisab Value",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${nisab.toStringAsFixed(2)} BDT", // Use toStringAsFixed for currency
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 4),
                    // const Text(
                    //   '(Updated: April 9, 2020)', // Keep date format consistent
                    //   style: TextStyle(
                    //       fontSize: 12,
                    //       color: Colors
                    //           .white60), // Slightly muted text for the date
                    // ),
                  ],
                ),
              ),
            ),

            // Input Fields
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSection(context, "Assets", [
                      _buildTextField(context, "Value Of Gold", _goldController,
                          TextInputType.number),
                      _buildTextField(context, "Value Of Silver",
                          _silverController, TextInputType.number),
                      _buildTextField(context, "Cash (Hand & Bank)",
                          _cashController, TextInputType.number),
                      _buildTextField(context, "Hajj Deposit",
                          _depositHajjController, TextInputType.number),
                      _buildTextField(context, "Loans Given Out",
                          _loanController, TextInputType.number),
                      _buildTextField(
                          context,
                          "Business Investments, Shares, etc.",
                          _savBusipenController,
                          TextInputType.number),
                    ]),
                    const SizedBox(height: 24), // Increased spacing
                    _buildSection(context, "Liabilities", [
                      _buildTextField(context, "Borrowed Money/Credit",
                          _creditController, TextInputType.number),
                      _buildTextField(context, "Wages Due", _wagesDueController,
                          TextInputType.number),
                      _buildTextField(context, "Taxes/Bills Due",
                          _taxDueController, TextInputType.number),
                    ]),
                    const SizedBox(height: 24), // Increased spacing

                    // Calculate Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyAppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2, // Consistent elevation
                      ),
                      onPressed: () => _calculateZakat(context),
                      child: Text(
                        "Calculate Zakat",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Zakat Payable Display (Conditional)
            if (payable > 0.0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: MyAppColors.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Payable Zakat",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${payable.toStringAsFixed(2)} BDT",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold), // Larger font for section titles
        ),
        const SizedBox(height: 12), // Spacing
        ...children,
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r"^\d+\.?\d{0,2}")), // Allows up to 2 decimal places
        ],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          // Muted label color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded borders
            borderSide: BorderSide(color: Colors.grey[400]!), // Lighter border
          ),
          focusedBorder: OutlineInputBorder(
            // Highlight on focus
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyAppColors.primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12), // Padding inside the TextField
        ),
      ),
    );
  }

  void _calculateZakat(BuildContext context) {
    // Helper function to parse text to double, handling null/empty cases
    double parseDouble(String? value) {
      return double.tryParse(value ?? "") ?? 0.0;
    }

    // Input validation using the controllers
    if (_goldController.text.isEmpty ||
        _silverController.text.isEmpty ||
        _cashController.text.isEmpty) {
      toastification.show(
        context: context,
        title: const Text("Please fill in all required fields."),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return; // Stop the calculation if validation fails
    }

    try {
      double asset = parseDouble(_goldController.text) +
          parseDouble(_silverController.text) +
          parseDouble(_cashController.text) +
          parseDouble(_depositHajjController.text) +
          parseDouble(_loanController.text) +
          parseDouble(_savBusipenController.text);

      double liabilitiesAmount = parseDouble(_creditController.text) +
          parseDouble(_wagesDueController.text) +
          parseDouble(_taxDueController.text);

      double totalAsset = asset - liabilitiesAmount;
      double zakatPayable = 0;

      if (totalAsset >= nisab) {
        zakatPayable = (totalAsset * 2.5) / 100;
      }

      setState(() {
        payable = zakatPayable;
      });
    } catch (e) {
      // More specific error handling, though the tryParse should handle most cases
      toastification.show(
        context: context,
        title: Text("Error during calculation: $e"),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:math';

class LoanCalculatorApp extends StatefulWidget {
  const LoanCalculatorApp({super.key});

  @override
  State<LoanCalculatorApp> createState() => _LoanCalculatorAppState();
}

class _LoanCalculatorAppState extends State<LoanCalculatorApp> {
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController loanTermController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  int loanTerm = 0, loanTermMonth = 0;
  double loanAmount = 0.0, interestRate = 0.0, monthlyPayment = 0.0;
  double totalInterest = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Calculator',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF162A84),
              ),
            ),
            const SizedBox(height: 40.0),
            Card(
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    buildTextField('Loan Amount', loanAmountController,
                        (value) {
                      loanAmount = double.parse(value);
                    }, 30.0),
                    const SizedBox(height: 10.0),
                    buildTextField('Loan Term', loanTermController, (value) {
                      loanTerm = int.parse(value);
                      loanTermMonth = loanTerm * 12;
                    }, 49.0),
                    const SizedBox(height: 10.0),
                    buildTextField('Interest Rate', interestRateController,
                        (value) {
                      interestRate = double.parse(value);
                    }, 33.0),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildButton('Calculate', () {
                          double monthlyInterestRate = interestRate / 100 / 12;
                          int totalPayments = loanTerm * 12;
                          double monthlyPaymentValue = (loanAmount *
                                  monthlyInterestRate) /
                              (1 -
                                  pow(1 + monthlyInterestRate, -totalPayments));
                          setState(() {
                            monthlyPayment = monthlyPaymentValue;
                            totalInterest =
                                (monthlyPayment * totalPayments - loanAmount);
                          });
                        }),
                        const SizedBox(
                            width: 10.0), // Add space between buttons
                        buildButton('Clear', () {
                          loanAmountController.clear();
                          loanTermController.clear();
                          interestRateController.clear();
                        }, showIcon: false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildResultText(),
            Column(
              children: [
                buildInfoText(
                    'You will need to pay \$${monthlyPayment.toStringAsFixed(2)} every month for $loanTerm years to payoff the debt.'),
                buildInfoTable('Total of $loanTermMonth Payments',
                    '\$${(monthlyPayment * loanTermMonth).toStringAsFixed(2)}'),
                buildInfoTable(
                    'Total Interest', '\$${totalInterest.toStringAsFixed(2)}'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      Function(String) onChanged, double spacing) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: spacing), // Add custom space between text and textField
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label == 'Loan Amount'
                  ? '\$100,000'
                  : (label == 'Loan Term' ? 'in years' : 'in %'),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            ),
            keyboardType: TextInputType.number,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget buildButton(String label, void Function() onPressed,
      {bool showIcon = true}) {
    Color buttonColor =
        label == 'Calculate' ? const Color(0xFF408230) : Colors.grey;

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
          side: BorderSide.none,
        )),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          if (showIcon) const SizedBox(width: 10),
          if (showIcon) const Icon(Icons.play_circle_fill),
        ],
      ),
    );
  }

  Widget buildResultText() {
    return Container(
      color: const Color(0xFF408230),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Monthly Payment:',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Text(
              '\$${monthlyPayment.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoText(String text) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15.0, color: Colors.black),
      ),
    );
  }

  Widget buildInfoTable(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD3D0D0)),
        color: label == 'Total Interest' ? Colors.white : Colors.grey[300],
      ),
      child: Table(
        children: [
          TableRow(
            children: [
              TableCell(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              TableCell(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

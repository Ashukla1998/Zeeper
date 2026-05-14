import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function({
    required double amount,
    required String paymentType,
    required String category,
    required String note,
    required bool isExpense,
  })
  onAdd;

  const AddExpenseScreen({super.key, required this.onAdd});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final amountController = TextEditingController();

  final noteController = TextEditingController();

  String selectedCategory = "Food";

  String paymentType = "UPI";

  bool isExpense = true;

  final categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Recharge",
    "Entertainment",
    "Health",
    "Rent",
    "Salary",
    "Other",
  ];

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();

    super.dispose();
  }

  void saveExpense() {
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter valid amount")));

      return;
    }

    widget.onAdd(
      amount: amount,
      paymentType: paymentType,
      category: selectedCategory,
      note: noteController.text.trim(),
      isExpense: isExpense,
    );

    amountController.clear();

    noteController.clear();

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Transaction Added")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Add Expense"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // AMOUNT
            TextField(
              controller: amountController,

              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),

              style: const TextStyle(color: Colors.white),

              decoration: inputDecoration("Amount"),
            ),

            const SizedBox(height: 20),

            // CATEGORY
            DropdownButtonFormField<String>(
              value: selectedCategory,

              dropdownColor: const Color(0xFF1E1E1E),

              decoration: inputDecoration("Category"),

              style: const TextStyle(color: Colors.white),

              items: categories.map((e) {
                return DropdownMenuItem<String>(value: e, child: Text(e));
              }).toList(),

              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // PAYMENT TYPE
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: paymentType == "Cash"
                          ? Colors.green
                          : Colors.grey.shade800,

                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),

                    onPressed: () {
                      setState(() {
                        paymentType = "Cash";
                      });
                    },

                    child: const Text("Cash"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: paymentType == "UPI"
                          ? Colors.blue
                          : Colors.grey.shade800,

                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),

                    onPressed: () {
                      setState(() {
                        paymentType = "UPI";
                      });
                    },

                    child: const Text("UPI"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // INCOME / EXPENSE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),

              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),

                borderRadius: BorderRadius.circular(14),
              ),

              child: SwitchListTile(
                value: isExpense,

                activeColor: Colors.red,

                title: Text(
                  isExpense ? "Expense" : "Income",

                  style: const TextStyle(color: Colors.white),
                ),

                onChanged: (v) {
                  setState(() {
                    isExpense = v;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // NOTE
            TextField(
              controller: noteController,

              maxLines: 2,

              style: const TextStyle(color: Colors.white),

              decoration: inputDecoration("Note"),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: saveExpense,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,

                  padding: const EdgeInsets.symmetric(vertical: 16),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: const Text("Save Transaction"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(color: Colors.grey),

      filled: true,

      fillColor: const Color(0xFF1E1E1E),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(color: Colors.green),
      ),
    );
  }
}

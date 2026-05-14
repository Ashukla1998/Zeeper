import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const AnalyticsScreen({super.key, required this.transactions});

  // TOTAL EXPENSE
  double getExpense() {
    return transactions
        .where((t) => t["isExpense"] == true)
        .fold(0.0, (sum, item) => sum + (item["amount"] as double));
  }

  // CATEGORY TOTAL
  double getCategoryTotal(String category) {
    return transactions
        .where((t) => t["isExpense"] == true && t["category"] == category)
        .fold(0.0, (sum, item) => sum + (item["amount"] as double));
  }

  @override
  Widget build(BuildContext context) {
    final totalExpense = getExpense();

    final categories = [
      "Food",
      "Travel",
      "Shopping",
      "Bills",
      "Recharge",
      "Entertainment",
      "Health",
      "Rent",
      "Other",
    ];

    final categoryData = categories
        .map((category) {
          final amount = getCategoryTotal(category);

          return {"category": category, "amount": amount};
        })
        .where((item) => (item["amount"] as double) > 0)
        .toList();

    // SORT HIGHEST TO LOWEST
    categoryData.sort(
      (a, b) => (b["amount"] as double).compareTo(a["amount"] as double),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Analytics"),
      ),

      body: totalExpense == 0
          ? const Center(
              child: Text(
                "No expense data available",

                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // TOTAL EXPENSE CARD
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withValues(alpha: 0.7),

                          Colors.red.withValues(alpha: 0.3),
                        ],
                      ),

                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Total Expense",

                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "₹${totalExpense.toStringAsFixed(2)}",

                          style: const TextStyle(
                            color: Colors.white,

                            fontSize: 34,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // TITLE
                  const Text(
                    "Category Breakdown",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CATEGORY LIST
                  ...categoryData.map((item) {
                    final category = item["category"] as String;

                    final amount = item["amount"] as double;

                    final percent = amount / totalExpense;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),

                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(
                                category,

                                style: const TextStyle(
                                  color: Colors.white,

                                  fontSize: 16,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                "₹${amount.toStringAsFixed(2)}",

                                style: const TextStyle(
                                  color: Colors.red,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // PROGRESS BAR
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),

                            child: LinearProgressIndicator(
                              value: percent,

                              minHeight: 12,

                              backgroundColor: Colors.grey.shade800,

                              valueColor: const AlwaysStoppedAnimation(
                                Colors.red,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,

                            child: Text(
                              "${(percent * 100).toStringAsFixed(1)}%",

                              style: const TextStyle(
                                color: Colors.grey,

                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}

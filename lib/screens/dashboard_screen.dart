import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const DashboardScreen({super.key, required this.transactions});

  // TOTAL INCOME
  double getIncome() {
    return transactions
        .where((t) => t["isExpense"] == false)
        .fold(0, (sum, item) => sum + item["amount"]);
  }

  // TOTAL EXPENSE
  double getExpense() {
    return transactions
        .where((t) => t["isExpense"] == true)
        .fold(0, (sum, item) => sum + item["amount"]);
  }

  @override
  Widget build(BuildContext context) {
    final income = getIncome();

    final expense = getExpense();

    final balance = income - expense;

    final recentTransactions = transactions.reversed.toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 20),

                const Text(
                  "Current Balance",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 10),

                Text(
                  "₹${balance.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: buildCard(
                        title: "Income",
                        amount: income,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: buildCard(
                        title: "Expense",
                        amount: expense,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Total Transactions",
                        style: TextStyle(color: Colors.grey),
                      ),

                      Text(
                        transactions.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Recent Transactions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: recentTransactions.isEmpty
                      ? const Center(
                          child: Text(
                            "No Transactions Yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: recentTransactions.length > 5
                              ? 5
                              : recentTransactions.length,

                          itemBuilder: (context, index) {
                            final t = recentTransactions[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),

                              padding: const EdgeInsets.all(16),

                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),

                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: t["isExpense"]
                                        ? Colors.red
                                        : Colors.green,

                                    child: Icon(
                                      t["isExpense"]
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,

                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          t["category"],

                                          style: const TextStyle(
                                            color: Colors.white,

                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          t["note"],

                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),

                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "₹${t["amount"]}",

                                    style: TextStyle(
                                      color: t["isExpense"]
                                          ? Colors.red
                                          : Colors.green,

                                      fontWeight: FontWeight.bold,

                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard({
    required String title,
    required double amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.7), color.withValues(alpha: 0.3)],
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 10),

          Text(
            "₹${amount.toStringAsFixed(2)}",

            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

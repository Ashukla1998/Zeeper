import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  final Function(int) onDelete;

  const HistoryScreen({
    super.key,
    required this.transactions,
    required this.onDelete,
  });

  // GROUP BY DATE
  Map<String, List<Map<String, dynamic>>> groupByDate() {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var t in transactions) {
      DateTime date;

      if (t["date"] != null) {
        date = t["date"];
      } else {
        date = DateTime.now();
      }

      String key = DateFormat('yyyy-MM-dd').format(date);

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }

      grouped[key]!.add(t);
    }

    return grouped;
  }

  // DATE LABEL
  String getLabel(String dateKey) {
    DateTime date = DateTime.parse(dateKey);

    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupByDate();

    final keys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("History"),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: transactions.isEmpty
              ? const Center(
                  child: Text(
                    "No transactions yet",

                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),

                  children: keys.map((dateKey) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // DATE HEADER
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),

                          child: Text(
                            getLabel(dateKey),

                            style: const TextStyle(
                              color: Colors.grey,

                              fontSize: 16,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // ITEMS
                        ...grouped[dateKey]!.asMap().entries.map((entry) {
                          int localIndex = entry.key;

                          var t = entry.value;

                          int originalIndex = transactions.indexOf(t);

                          return Dismissible(
                            key: ValueKey("${t["date"]}_${t["amount"]}"),

                            direction: DismissDirection.endToStart,

                            onDismissed: (_) {
                              onDelete(originalIndex);
                            },

                            background: Container(
                              margin: const EdgeInsets.only(bottom: 10),

                              padding: const EdgeInsets.only(right: 20),

                              alignment: Alignment.centerRight,

                              decoration: BoxDecoration(
                                color: Colors.red,

                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: const Icon(
                                Icons.delete,

                                color: Colors.white,
                              ),
                            ),

                            child: buildCard(t, localIndex),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }

  // CARD
  Widget buildCard(Map<String, dynamic> t, int index) {
    Color color = t["isExpense"] ? Colors.red : Colors.green;

    DateTime date = t["date"] ?? DateTime.now();

    Widget card = Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8),
        ],
      ),

      child: Row(
        children: [
          // ICON
          CircleAvatar(
            backgroundColor: color,

            child: Icon(
              t["isExpense"] ? Icons.arrow_upward : Icons.arrow_downward,

              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  t["category"],

                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  t["note"].toString().isEmpty ? "No Note" : t["note"],

                  style: const TextStyle(color: Colors.grey),

                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  "${t["paymentType"]} • ${DateFormat('hh:mm a').format(date)}",

                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          // AMOUNT
          Text(
            "₹${t["amount"].toStringAsFixed(2)}",

            style: TextStyle(
              color: color,

              fontWeight: FontWeight.bold,

              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    // ANIMATION
    if (index < 8) {
      return TweenAnimationBuilder(
        duration: Duration(milliseconds: 200 + (index * 50)),

        tween: Tween<double>(begin: 0, end: 1),

        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - value)),

            child: Opacity(opacity: value, child: child),
          );
        },

        child: card,
      );
    }

    return card;
  }
}

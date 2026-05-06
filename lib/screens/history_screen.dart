import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  // final List<Map<String, dynamic>> transactions;

  // HistoryScreen({required this.transactions});
  final List<Map<String, dynamic>> transactions;
  final Function(int) onDelete;

  HistoryScreen({
    super.key,
    required this.transactions,
    required this.onDelete,
  });

  // 🔥 GROUP BY DATE (SAFE VERSION)
  Map<String, List<Map<String, dynamic>>> groupByDate() {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var t in transactions) {
      DateTime date;

      // ✅ SAFETY FIX (no crash)
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

  // 🧠 LABELS
  String getLabel(String dateKey) {
    DateTime date = DateTime.parse(dateKey);
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupByDate();
    final keys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: transactions.isEmpty
              ? Center(
                  child: Text(
                    "No transactions yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.all(16),
                  children: keys.map((dateKey) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 📅 DATE HEADER
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            getLabel(dateKey),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 🧾 ITEMS
                        ...grouped[dateKey]!.asMap().entries.map((entry) {
                          int localIndex = entry.key;
                          var t = entry.value;

                          int originalIndex = transactions.indexOf(t);

                          return Dismissible(
                            key: UniqueKey(),

                            direction: DismissDirection.endToStart,

                            onDismissed: (_) {
                              onDelete(originalIndex);
                            },

                            background: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.only(right: 20),
                              alignment: Alignment.centerRight,

                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: Icon(Icons.delete, color: Colors.white),
                            ),

                            child: buildCard(t, localIndex),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }

  // 🔥 SAFE + LIGHT CARD
  Widget buildCard(Map<String, dynamic> t, int index) {
    Color color = t["type"] == "cash" ? Colors.green : Colors.blue;

    DateTime date = t["date"] != null ? t["date"] : DateTime.now();

    Widget card = Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8)],
      ),
      child: Row(
        children: [
          // LEFT INDICATOR
          Container(
            width: 5,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          SizedBox(width: 12),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t["type"].toUpperCase(),
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('hh:mm a').format(date),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          // AMOUNT
          Text(
            "₹${t["amount"].toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    // ✅ LIMITED ANIMATION (only first 8 items)
    if (index < 8) {
      return TweenAnimationBuilder(
        duration: Duration(milliseconds: 250),
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

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  DashboardScreen({required this.transactions});

  double getTotal() =>
      transactions.fold(0, (sum, item) => sum + item["amount"]);

  double getCash() => transactions
      .where((t) => t["type"] == "cash")
      .fold(0, (sum, item) => sum + item["amount"]);

  double getUpi() => transactions
      .where((t) => t["type"] == "upi")
      .fold(0, (sum, item) => sum + item["amount"]);

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                // 🔝 TOTAL BALANCE
                Text(
                  "Total Balance",
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),

                SizedBox(height: 10),

                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: getTotal()),
                  duration: Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Text(
                      "₹${value.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),

                SizedBox(height: 40),

                // 💳 CARDS
                Row(
                  children: [
                    Expanded(
                      child: buildCard(
                        title: "Cash",
                        amount: getCash(),
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: buildCard(
                        title: "UPI",
                        amount: getUpi(),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // 📊 EXTRA INFO
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transactions",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "${transactions.length}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 💳 CARD UI
  Widget buildCard({
    required String title,
    required double amount,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.7), color.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 16)),

          SizedBox(height: 10),

          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: amount),
            duration: Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Text(
                "₹${value.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

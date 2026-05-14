import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'add_expense_screen.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'analytics_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  List<Map<String, dynamic>> transactions = [];

  // HIVE BOX
  final box = Hive.box('transactions');

  @override
  void initState() {
    super.initState();

    loadTransactions();
  }

  // LOAD DATA
  void loadTransactions() {
    final data = box.values.toList();

    if (!mounted) return;

    setState(() {
      transactions = data.map((item) {
        return {
          "amount": item["amount"],
          "paymentType": item["paymentType"],
          "category": item["category"],
          "note": item["note"],
          "isExpense": item["isExpense"],
          "date": DateTime.parse(item["date"]),
        };
      }).toList();
    });
  }

  // ADD TRANSACTION
  void addTransaction({
    required double amount,
    required String paymentType,
    required String category,
    required String note,
    required bool isExpense,
  }) {
    final transaction = {
      "amount": amount,
      "paymentType": paymentType,
      "category": category,
      "note": note,
      "isExpense": isExpense,
      "date": DateTime.now().toIso8601String(),
    };

    // SAVE TO HIVE
    box.add(transaction);

    // REFRESH UI
    loadTransactions();
  }

  // DELETE TRANSACTION
  void deleteTransaction(int index) async {
    await box.deleteAt(index);

    loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,

        children: [
          DashboardScreen(transactions: transactions),

          AddExpenseScreen(onAdd: addTransaction),

          HistoryScreen(
            transactions: transactions,
            onDelete: deleteTransaction,
          ),

          AnalyticsScreen(transactions: transactions),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,

        onTap: (i) {
          setState(() {
            selectedIndex = i;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedFontSize: 12,
        unselectedFontSize: 11,
        iconSize: 22,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Add"),

          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),

          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Analytics",
          ),
        ],
      ),
    );
  }
}

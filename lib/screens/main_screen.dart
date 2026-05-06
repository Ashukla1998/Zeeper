// import 'package:flutter/material.dart';
// import 'calculator_screen.dart';
// import 'dashboard_screen.dart';
// import 'history_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int selectedIndex = 0;

//   List<Map<String, dynamic>> transactions = [];

//   void addTransaction(double amount, String type) {
//     setState(() {
//       transactions.add({
//         "amount": amount,
//         "type": type,
//         "date": DateTime.now(),
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       CalculatorScreen(onAdd: addTransaction),
//       DashboardScreen(transactions: transactions),
//       HistoryScreen(transactions: transactions),
//     ];

//     return Scaffold(
//       body: screens[selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex,
//         onTap: (i) => setState(() => selectedIndex = i),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Calc"),
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dash"),
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: "History"),
//         ],
//       ),
//     );
//   }
// }
// main_screen.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'calculator_screen.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';

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

    setState(() {
      transactions = data.map((item) {
        return {
          "amount": item["amount"],
          "type": item["type"],
          "date": DateTime.parse(item["date"]),
        };
      }).toList();
    });
  }

  // ADD TRANSACTION
  void addTransaction(double amount, String type) {
    final transaction = {
      "amount": amount,
      "type": type,
      "date": DateTime.now().toIso8601String(),
    };

    // SAVE TO HIVE
    box.add(transaction);

    // UPDATE UI
    setState(() {
      transactions.add({
        "amount": amount,
        "type": type,
        "date": DateTime.parse(transaction["date"].toString()),
      });
    });
  }

  // DELETE TRANSACTION
  void deleteTransaction(int index) async {
    await box.deleteAt(index);

    loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      CalculatorScreen(onAdd: addTransaction),

      DashboardScreen(transactions: transactions),

      HistoryScreen(transactions: transactions, onDelete: deleteTransaction),
    ];

    return Scaffold(
      body: screens[selectedIndex],

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
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Calc"),

          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dash"),

          BottomNavigationBarItem(icon: Icon(Icons.list), label: "History"),
        ],
      ),
    );
  }
}

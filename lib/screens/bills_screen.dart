import 'package:flutter/material.dart';

import 'create_bill_screen.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Bills"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateBillScreen()),
          );
        },

        child: const Icon(Icons.add),
      ),

      body: const Center(
        child: Text("No Bills Yet", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

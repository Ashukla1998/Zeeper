// bills_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../services/bill_storage.dart';
import 'create_bill_screen.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  // BILL HISTORY
  List<Map> bills = [];

  @override
  void initState() {
    super.initState();

    loadBills();
  }

  // LOAD BILLS
  void loadBills() async {
    final data = await BillStorage.getBills();

    setState(() {
      bills = data;
    });
  }

  // OPEN PDF
  void openBill(String path) async {
    final file = File(path);

    if (await file.exists()) {
      await OpenFilex.open(path);
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("PDF file not found")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text("Bills"),
      ),

      // ADD BILL
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,

        onPressed: () async {
          await Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const CreateBillScreen()),
          );

          loadBills();
        },

        child: const Icon(Icons.add),
      ),

      // BODY
      body: bills.isEmpty
          // EMPTY
          ? const Center(
              child: Text(
                "No Bills Yet",

                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
          // BILL LIST
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: bills.length,

              itemBuilder: (context, index) {
                final bill = bills[index];

                return GestureDetector(
                  // OPEN PDF
                  onTap: () {
                    if (bill["path"] != null) {
                      openBill(bill["path"]);
                    }
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),

                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // LEFT SIDE
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // CUSTOMER
                              Text(
                                bill["customer"] ?? "",

                                style: const TextStyle(
                                  color: Colors.white,

                                  fontSize: 18,

                                  fontWeight: FontWeight.bold,
                                ),

                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 6),

                              // DATE
                              Text(
                                bill["date"] ?? "",

                                style: const TextStyle(
                                  color: Colors.grey,

                                  fontSize: 12,
                                ),

                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 8),

                              // STATUS
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,

                                  vertical: 4,
                                ),

                                decoration: BoxDecoration(
                                  color: bill["status"] == "Paid"
                                      ? Colors.green.withValues(alpha: 0.2)
                                      : Colors.orange.withValues(alpha: 0.2),

                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Text(
                                  bill["status"] ?? "",

                                  style: TextStyle(
                                    color: bill["status"] == "Paid"
                                        ? Colors.green
                                        : Colors.orange,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // TOTAL
                        Text(
                          "Rs. ${bill["total"]}",

                          style: const TextStyle(
                            color: Colors.green,

                            fontSize: 18,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

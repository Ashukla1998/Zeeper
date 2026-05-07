import 'package:flutter/material.dart';
import '../services/bill_storage.dart';
import 'create_bill_screen.dart';
// import 'package:share_plus/share_plus.dart';

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

  void loadBills() async {
    final data = await BillStorage.getBills();

    setState(() {
      bills = data;
    });
  }

  // ADD BILL
  void addBill({required String customer, required String total}) {
    setState(() {
      bills.add({
        "customer": customer,

        "total": total,

        "date": DateTime.now().toString(),
      });
    });
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,

        onPressed: () async {
          final result = await Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const CreateBillScreen()),
          );

          // RECEIVE GENERATED BILL
          if (result != null) {
            addBill(customer: result["customer"], total: result["total"]);
          }
        },

        child: const Icon(Icons.add),
      ),

      // BILL LIST
      body: bills.isEmpty
          // EMPTY STATE
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

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),

                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      // LEFT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            bill["customer"],

                            style: const TextStyle(
                              color: Colors.white,

                              fontSize: 18,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            bill["date"],

                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      // RIGHT
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
                );
              },
            ),
    );
  }
}

// create_bill_screen.dart

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../models/bill_model.dart';
import '../services/pdf_service.dart';
import '../services/bill_storage.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final customerController = TextEditingController();

  final shopController = TextEditingController();

  List<BillItem> items = [BillItem(item: '', qty: 1, rate: 0)];

  // TOTAL
  double get total {
    double sum = 0;

    for (var item in items) {
      sum += item.amount;
    }

    return sum;
  }

  // ADD NEW ROW
  void addRow() {
    setState(() {
      items.add(BillItem(item: '', qty: 1, rate: 0));
    });
  }

  // REMOVE ROW
  void removeRow(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text("Create Bill"),

        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),

          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,

              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),

            child: Column(
              children: [
                // SHOP NAME
                TextField(
                  controller: shopController,

                  style: const TextStyle(color: Colors.white),

                  decoration: inputDecoration("Shop Name"),
                ),

                const SizedBox(height: 12),

                // CUSTOMER NAME
                TextField(
                  controller: customerController,

                  style: const TextStyle(color: Colors.white),

                  decoration: inputDecoration("Customer Name"),
                ),

                const SizedBox(height: 20),

                // ITEM LIST
                ListView.builder(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: items.length,

                  itemBuilder: (context, index) {
                    return itemRow(index);
                  },
                ),

                const SizedBox(height: 10),

                // ADD ITEM BUTTON
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: addRow,

                    icon: const Icon(Icons.add),

                    label: const Text("Add Item"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,

                      padding: const EdgeInsets.symmetric(vertical: 16),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TOTAL
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),

                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Text(
                    "Total: Rs. ${total.toStringAsFixed(2)}",

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 24,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // GENERATE BILL BUTTON
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // VALIDATION
                      if (shopController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter Shop Name")),
                        );

                        return;
                      }

                      if (customerController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter Customer Name")),
                        );

                        return;
                      }

                      // GENERATE PDF
                      final file = await PdfService.generateBill(
                        shopName: shopController.text,

                        customerName: customerController.text,

                        items: items,

                        total: total,
                      );

                      await Printing.layoutPdf(
                        onLayout: (_) async {
                          return await file.readAsBytes();
                        },
                      );

                      // CHECK IF SCREEN STILL EXISTS
                      if (!mounted) return;

                      await BillStorage.saveBill({
                        "customer": customerController.text,

                        "total": total.toStringAsFixed(2),

                        "date": DateTime.now().toString(),

                        "path": file.path,
                      });

                      // SEND BILL DATA BACK
                      Navigator.pop(context, {
                        "customer": customerController.text,

                        "total": total.toStringAsFixed(2),

                        "path": file.path,
                      });
                    },

                    icon: const Icon(Icons.picture_as_pdf),

                    label: const Text("Generate Bill"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,

                      padding: const EdgeInsets.symmetric(vertical: 16),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ITEM ROW
  Widget itemRow(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),

        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        children: [
          // ITEM NAME
          TextField(
            style: const TextStyle(color: Colors.white),

            decoration: inputDecoration("Item Name"),

            onChanged: (v) {
              items[index].item = v;
            },
          ),

          const SizedBox(height: 10),

          // QTY + RATE
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,

                  style: const TextStyle(color: Colors.white),

                  decoration: inputDecoration("Qty"),

                  onChanged: (v) {
                    items[index].qty = double.tryParse(v) ?? 0;

                    setState(() {});
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,

                  style: const TextStyle(color: Colors.white),

                  decoration: inputDecoration("Rate"),

                  onChanged: (v) {
                    items[index].rate = double.tryParse(v) ?? 0;

                    setState(() {});
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // AMOUNT + DELETE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              IconButton(
                onPressed: () {
                  if (items.length > 1) {
                    removeRow(index);
                  }
                },

                icon: const Icon(Icons.delete, color: Colors.red),
              ),

              Text(
                "Amount: Rs. ${items[index].amount.toStringAsFixed(2)}",

                style: const TextStyle(
                  color: Colors.green,

                  fontWeight: FontWeight.bold,

                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // INPUT DESIGN
  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(color: Colors.grey),

      filled: true,

      fillColor: const Color(0xFF2A2A2A),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide.none,
      ),
    );
  }
}

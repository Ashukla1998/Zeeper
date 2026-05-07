import 'package:hive/hive.dart';

class BillStorage {
  static const String boxName = "billsBox";

  // OPEN BOX
  static Future<Box> openBox() async {
    return await Hive.openBox(boxName);
  }

  // SAVE BILL
  static Future<void> saveBill(Map<String, dynamic> bill) async {
    final box = await openBox();

    await box.add(bill);
  }

  // GET ALL BILLS
  static Future<List<Map>> getBills() async {
    final box = await openBox();

    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // DELETE BILL
  static Future<void> deleteBill(int index) async {
    final box = await openBox();

    await box.deleteAt(index);
  }
}

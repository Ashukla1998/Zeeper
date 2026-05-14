class ExpenseModel {
  double amount;
  String category;
  String paymentType;
  String note;
  bool isExpense;
  DateTime date;

  ExpenseModel({
    required this.amount,
    required this.category,
    required this.paymentType,
    required this.note,
    required this.isExpense,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'paymentType': paymentType,
      'note': note,
      'isExpense': isExpense,
      'date': date.toIso8601String(),
    };
  }

  factory ExpenseModel.fromMap(Map map) {
    return ExpenseModel(
      amount: map['amount'],
      category: map['category'],
      paymentType: map['paymentType'],
      note: map['note'],
      isExpense: map['isExpense'],
      date: DateTime.parse(map['date']),
    );
  }
}

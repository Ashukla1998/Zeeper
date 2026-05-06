class BillItem {
  String item;
  double qty;
  double rate;

  BillItem({required this.item, required this.qty, required this.rate});

  double get amount => qty * rate;
}

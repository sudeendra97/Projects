class QuotationData {
  final List emails;
  final List uid;
  final List vendorNames;
  final String itemDescription;
  final String quantity;
  final String costOfItem;
  final String vendorSKU;
  final String beSKU;
  var date;
  var initdate;

  QuotationData({
    required this.emails,
    required this.uid,
    required this.vendorNames,
    required this.itemDescription,
    required this.quantity,
    required this.costOfItem,
    required this.vendorSKU,
    required this.beSKU,
    this.date,
    this.initdate,
  });
}

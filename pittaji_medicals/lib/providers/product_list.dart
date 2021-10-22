class ProductList {
  final String productName;
  final String batchNumber;
  final String qty;
  final String mrp;
  final int expiryDate;
  final String vendorName;
  final String margin;
  final String monthsToExpiry;

  ProductList({
    required this.productName,
    required this.batchNumber,
    required this.qty,
    required this.mrp,
    required this.expiryDate,
    required this.vendorName,
    required this.margin,
    required this.monthsToExpiry,
  });
}

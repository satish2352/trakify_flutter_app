class Flat {
  final String id;
  final String flatNumber;
  final String flatStatus;
  final int area;
  final int price;
  final String bhk;
  String? comment;
  String? lastUpdated;
  final String customerName = "Dummy Customer";
  final int customerNumber = 9955887766;

  Flat({
    required this.id,
    required this.flatNumber,
    required this.flatStatus,
    required this.area,
    required this.price,
    required this.bhk,
    this.comment,
    this.lastUpdated,
  });

  factory Flat.fromJson(Map<String, dynamic> json) {
    return Flat(
      id: json['_id'],
      flatNumber: json['flatNumber'],
      flatStatus: json['status'],
      area: json['area'],
      price: json['price'],
      bhk: (json['bhk'] as num).toString(),
      comment: json['comment'],
      lastUpdated: json['lastUpdated'],
    );
  }
}

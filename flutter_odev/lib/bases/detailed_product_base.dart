import 'package:cloud_firestore/cloud_firestore.dart';

class DetailedProduct {
  late String market, user, name, barcode;
  late double price;
  String? image;
  DateTime? priceDate;


  DetailedProduct({
    this.image,
    this.priceDate,
    required this.market,
    required this.name,
    required this.barcode,
    required this.price,
    required this.user,

  });

  DetailedProduct.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        barcode = map["barcode"],
        market = map["market"],
        priceDate = (map["priceDate"] as Timestamp).toDate(),
        price = (map["price"] is int
            ? double.parse(map["price"].toString())
            : map["price"]),
        user = map["user"],
        image = map["image"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": image,
      "barcode": barcode,
      "market": market,
      "user": user,
      "price": price,
      "priceDate": FieldValue.serverTimestamp(),
    };
  }

  compareTo(DetailedProduct b) {}
}

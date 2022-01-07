class Product {
  late String name, image, barcode;

  Product({
    required this.barcode,
    required this.name,
    required this.image,
  });

  Product.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        barcode = map["barcode"],
        image = map["image"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": image,
      "barcode": barcode,
    };
  }
}

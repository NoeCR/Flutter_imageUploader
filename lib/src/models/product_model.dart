import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String title;
  double price;
  bool avaible;
  String photoUrl;

  ProductModel({
    this.id,
    this.title = '',
    this.price = 0.0,
    this.avaible = true,
    this.photoUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        avaible: json["avaible"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "title": title,
        "price": price,
        "avaible": avaible,
        "photoUrl": photoUrl,
      };
}

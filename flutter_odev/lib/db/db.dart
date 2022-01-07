import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_odev/bases/detailed_product_base.dart';
import 'package:flutter_odev/bases/product_base.dart';
import 'package:flutter_odev/bases/user_base.dart';

class Database {
  final _fireStore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>>? _querySnapshot;
  DocumentSnapshot<Map<String, dynamic>>? _documentSnapshot;
  List<Product> _products = [];

  Future<List<Product>?> getProductsWithName(String productName) async {
    _querySnapshot = await _fireStore
        .collection("products")
        .where("name", isGreaterThanOrEqualTo: productName)
        .get();
    if (_querySnapshot!.docs.isNotEmpty) {
      _querySnapshot!.docs.forEach((element) {
        print(element.data());
        Product product = Product.fromMap(element.data());
        _products.add(product);
      });
      return _products;
    } else {
      return null;
    }
  }

  Future<List<DetailedProduct>?> getProductWithBarcode(String barcode) async {
    List<DetailedProduct>? _productsWithMarkets = [];
    _querySnapshot = await _fireStore
        .collection("products")
        .doc(barcode)
        .collection("markets")
        .orderBy("price")
        .get();
    if (_querySnapshot!.docs.isEmpty) {
      return null;
    } else {
      _querySnapshot!.docs.forEach((element) {
        DetailedProduct _detailedProduct =
            DetailedProduct.fromMap(element.data());
        print("BULUNAN OGE ---> " + _detailedProduct.name);
        _productsWithMarkets.add(_detailedProduct);
      });
      return _productsWithMarkets;
    }
  }

  Future<List<DetailedProduct>?> getProductWithMarkets(String barcode) async {
    List<DetailedProduct>? _productsWithMarkets;
    _querySnapshot = await _fireStore
        .collection("products")
        .doc(barcode)
        .collection("markets")
        .orderBy("price")
        .get();
    if (_querySnapshot!.docs.isNotEmpty) {
      _querySnapshot!.docs.forEach((element) {
        DetailedProduct _detailedProduct =
            DetailedProduct.fromMap(element.data());
        _productsWithMarkets!.add(_detailedProduct);
      });
      return _productsWithMarkets;
    } else {
      return null;
    }
  }

  Future<void> createProduct(DetailedProduct product) async {
    try {
      await _fireStore.collection("products").doc(product.barcode).set({
        "name": product.name,
        "image": product.image,
        "barcode": product.barcode,
      });
      await _fireStore
          .collection("products")
          .doc(product.barcode)
          .collection("markets")
          .doc(product.market)
          .set(product.toMap());
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> updatePassword(String password, username) async {
    try {
      await _fireStore
          .collection("users")
          .doc(username)
          .update({"password": password});
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  Future<void> updateProfilePhoto(String profileUrl, username) async {
    try {
      await _fireStore
          .collection("users")
          .doc(username)
          .update({"profileUrl": profileUrl});
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  Future<void> deleteAccount(String username) async {
    try {
      await _fireStore.collection("users").doc(username).delete();
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  Future<void> followProduct(String barcode, username) async {
    await _fireStore.collection("users").doc(username).update({
      "products": FieldValue.arrayUnion([barcode])
    });
  }

  Future<void> unfollowProduct(String barcode, username) async {
    await _fireStore.collection("users").doc(username).update({
      "products": FieldValue.arrayRemove([barcode]),
    });
  }

  Future<bool> checkFollowing(String barcode, username) async {
    bool _value = false;
    _documentSnapshot =
        await _fireStore.collection("users").doc(username).get();
    User _user = User.fromMap(_documentSnapshot!.data()!);
    if (_user.products != null) {
      _value = _user.products!.contains(barcode);
      return _value;
    } else {
      return false;
    }
  }

  Future<List<Product>?> getFollowingProducts(String username) async {
    List<Product> _products = [];
    _documentSnapshot =
        await _fireStore.collection("users").doc(username).get();
    User _user = User.fromMap(_documentSnapshot!.data()!);
    if (_user.products != null&&_user.products!.isNotEmpty) {
      _user.products!.forEach((String barcode) async {
        _documentSnapshot =
            await _fireStore.collection("products").doc(barcode).get();
        print("MAP ---->" + _documentSnapshot!.data().toString());
        Product _product = Product.fromMap(_documentSnapshot!.data()!);
        _products.add(_product);
      });
      return _products;
    } else {
      return null;
    }
  }
}

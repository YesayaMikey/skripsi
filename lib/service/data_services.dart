import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DataServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  static Future<void> addProduct({
    required String nameProduct,
    required String productPrice,
    required int totalProduct,
    required DateTime dateInput,
    required String imageUploadedPath,
  }) {
    // Call the user's CollectionReference to add a new user
    return products
        .add({
          'product_name': nameProduct,
          'product_price': productPrice,
          'total_product': totalProduct,
          'image_path': imageUploadedPath,
          'date_input': dateInput
        })
        .then((value) => debugPrint("Product Added"))
        .catchError((error) => debugPrint("Failed to add product: $error"));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DataServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference listbarangkeluar =
      FirebaseFirestore.instance.collection('barang_keluar');

  static CollectionReference brgmasuk =
      FirebaseFirestore.instance.collection('barang_masuk');

  static CollectionReference brgkeluar =
      FirebaseFirestore.instance.collection('barang_keluar');

  static CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  static CollectionReference jurnal =
      FirebaseFirestore.instance.collection('jurnal');

  static Future<void> updateprduct(
      {required String dropdownValue,
      required int jmlbrng,
      required DateTime dateInput}) async {
    // print("$dropdownValue,$jmlbrng,$dateInput");

    final productSelectedData = await FirebaseFirestore.instance
        // QUERY DI COLLLECTION PAKAI WHERE
        .collection('products')
        .where('product_name', isEqualTo: dropdownValue)
        .get();

    final productid = productSelectedData.docs.first.id;

    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    products
        .doc(productid)
        .update({'total_product': jmlbrng, 'date_input': dateInput})
        .then((value) => print("products $dropdownValue Updated"))
        .catchError(
            (error) => print("Failed to update $dropdownValue: $error"));

    debugPrint("id document -> $productid");

    try {
      // final datajurnal.where(field).get();

      jurnal
          .add({
            'Productname': dropdownValue,
            'qty': jmlbrng,
            'dateup': dateInput
          })
          .then((value) => debugPrint("jurnal Added"))
          .catchError((error) => debugPrint("Failed to add jurnal: $error"));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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

  static Future<void> brg_masuk({
    required String nameProduct,
    required String productPrice,
    required int totalProduct,
    required DateTime dateInput,
  }) {
    // Call the user's CollectionReference to add a new user
    return brgmasuk
        .add({
          'product_name': nameProduct,
          'product_price': productPrice,
          'total_product': totalProduct,
          'date_input': dateInput
        })
        .then((value) => debugPrint("brgmasuk Added"))
        .catchError((error) => debugPrint("Failed to add brgmasuk: $error"));
  }

  static Future<void> brg_keluar({
    required String nameProduct,
    required String productPrice,
    required int totalProduct,
    required DateTime dateInput,
  }) {
    // Call the user's CollectionReference to add a new user
    return brgkeluar
        .add({
          'product_name': nameProduct,
          'product_price': productPrice,
          'total_product': totalProduct,
          'date_input': dateInput
        })
        .then((value) => debugPrint("brgkeluar Added"))
        .catchError((error) => debugPrint("Failed to add brgkeluar: $error"));
  }

  static Future<void> list_barangkeluar(
      {required String nmbrng, required String displayjmlh}) async {
    final listkeluar = await FirebaseFirestore.instance
        // QUERY DI COLLLECTION PAKAI WHERE
        .collection('barang_keluar')
        .where('product_name', isEqualTo: 'kapal selam')
        .get();
    final productid = listkeluar.docs.first.id;
    debugPrint("id document -> $productid");
  }

  static Future<List<String>> fetchDesiredFieldValues() async {
    var collectionName = 'products'; // Replace with the actual collection name
    var fieldName = 'product_name'; // Replace with the actual field name
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    List<String> values = [];
    for (var doc in snapshot.docs) {
      values.add(doc[fieldName] as String);
    }
    return values;
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      docjmlh() async {
    var collectionName = 'barang_keluar';
    var fieldName = 'product_name';
    List<String> desiredFieldValues = await fetchDesiredFieldValues();
    return await FirebaseFirestore.instance
        // QUERY DI COLLLECTION PAKAI WHERE
        .collection(collectionName)
        .where(fieldName, whereIn: desiredFieldValues)
        .get()
        .then((QuerySnapshot) => QuerySnapshot.docs);
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      docjmlhmasuk() async {
    var collectionName = 'barang_masuk';
    var fieldName = 'product_name';
    List<String> desiredFieldValues = await fetchDesiredFieldValues();
    return await FirebaseFirestore.instance
        // QUERY DI COLLLECTION PAKAI WHERE
        .collection(collectionName)
        .where(fieldName, whereIn: desiredFieldValues)
        .get()
        .then((QuerySnapshot) => QuerySnapshot.docs);
  }
}

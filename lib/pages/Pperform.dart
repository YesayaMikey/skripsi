import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pperform extends StatefulWidget {
  const Pperform({super.key});
  static String path = "/Pperform";

  @override
  State<Pperform> createState() => _PperformState();
}

class _PperformState extends State<Pperform> {
  List<String> docjml = [];
  String nmbrng = "";
  String displayjmlh = "";

  Future docjmlh() async {
    return await FirebaseFirestore.instance

        // QUERY DI COLLLECTION PAKAI WHERE
        .collection('barang_keluar')
        .where('product_name=kapal selam')
        .orderBy('date_input', descending: true)
        .get()
        .then((snapshot) => snapshot.docs);
  }

  @override
  void initState() {
    docjmlh();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Performance'),
          backgroundColor: Colors.orange,
        ),
        body: Column(
          children: [
            Text('tets'),
            Row(
              children: [Text('nama barang=jumlah barang')],
            )
          ],
        ));
  }
}

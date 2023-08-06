import 'package:app_skripsi/pages/productlist/productlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class jurnal extends StatefulWidget {
  final String selectProduct;
  const jurnal({super.key, required this.selectProduct});
  static String path = "/jurnal";

  @override
  State<jurnal> createState() => _jurnalState();
}

class _jurnalState extends State<jurnal> {
  TextEditingController jmlbrng = TextEditingController();
  TextEditingController hrgbrng = TextEditingController();
  String dropdownValue = "pilih";
  String selectedProductName = "";
  String hintTextHarga = "";
  String hintTextJmlh = "";

  List<String> productListName = <String>["pilih"];

  Future<void> getCurrentHargaDanQty(
      {required String productSelectedName}) async {
    final productSelectedData = await FirebaseFirestore.instance
        // QUERY DI COLLLECTION PAKAI WHERE
        .collection('products')
        .where('product_name', isEqualTo: productSelectedName)
        .get();

    final product = productSelectedData.docs.first.data();

    debugPrint("Product get ==> ${productSelectedData.docs.first.data()}");

    setState(() {
      hintTextHarga = product['product_price'];
      hintTextJmlh = product['total_product'].toString();
    });
  }

  // get docID
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getProductListByName({required String productName}) async {
    return await FirebaseFirestore.instance
        // QUERY DI COLLLECTION PAKAI WHERE
        .collection('products')
        .orderBy('date_input', descending: true)
        .get()
        .then((snapshot) => snapshot.docs);
  }

  @override
  void initState() {
    setState(() {
      selectedProductName = widget.selectProduct;
    });

    Future.delayed(const Duration(milliseconds: 50), () async {
      if (selectedProductName.isNotEmpty) {
        dropdownValue = selectedProductName;
        await getCurrentHargaDanQty(productSelectedName: selectedProductName);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jurnal Input'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<Object>(
          future: getProductListByName(productName: selectedProductName),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              productListName = ["pilih"];
              // productList = snapshot.data!
              final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                  dataProduct = snapshot.data!
                      as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

              for (var data in dataProduct) {
                productListName.add(
                  data['product_name'],
                  //   DropdownMenuItem(
                  //   value: data['product_name'],
                  //   child: Text(data['product_name']),
                  // )
                );
              }
            }
            return Column(
              children: [
                DropdownButton<String>(
                  // isDense: true,
                  isExpanded: true,
                  value: dropdownValue,
                  items: productListName
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (String? value) async {
                    debugPrint("apa ya yang dipilih? $value");
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });

                    if (dropdownValue != "pilih") {
                      await getCurrentHargaDanQty(
                          productSelectedName: dropdownValue);
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText:
                        hintTextHarga.isNotEmpty ? hintTextHarga : 'harga',
                  ),
                  controller: hrgbrng,
                ),
                TextFormField(
                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value == '') {
                      return "wajib isi";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: hintTextJmlh.isNotEmpty
                        ? hintTextJmlh
                        : 'jumlah barang',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: jmlbrng,
                ),
              ],
            );
          }),
    );
  }
}

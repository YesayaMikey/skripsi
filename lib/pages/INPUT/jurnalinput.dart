// import 'dart:ffi';
// import 'dart:html';

import 'package:app_skripsi/pages/mainpage.dart';
import 'package:app_skripsi/pages/productlist/productlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../service/data_services.dart';

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
  String splitvalue = "pilih";
  String selectedProductName = "";
  String hintTextHarga = "";
  String hintTextJmlh = "";
  String Textjmlh = "";
  var Nbaru = int;
  int result = 0;
  int num1 = 0;
  int num2 = 0;
  DateTime? inputDate;
  bool isUpdateProduct = false;
  final _formstate = GlobalKey<FormState>();
  List<String> productListName = <String>["pilih"];

  Future<void> getCurrentHargaDanQty({
    required String productSelectedName,
  }) async {
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
        await getCurrentHargaDanQty(
          productSelectedName: selectedProductName,
        );
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
                );
              }
            }
            return Form(
              key: _formstate,
              child: Column(
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
                          productSelectedName: dropdownValue,
                        );
                      }
                    },
                  ),
                  DropdownButton<String>(
                      value: splitvalue,
                      items: [
                        DropdownMenuItem(
                          value: "pilih",
                          child: Text("pilih"),
                        ),
                        DropdownMenuItem(
                          value: "kurangi",
                          child: Text("kurangi"),
                        ),
                        DropdownMenuItem(
                          value: "tambahkan",
                          child: Text("tambahkan"),
                        ),
                      ],
                      onChanged: (String? value) {
                        debugPrint("apa ya yang dipilih? $value");
                        // This is called when the user selects an item.
                        setState(() {
                          splitvalue = value!;
                        });
                      }),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText:
                          hintTextHarga.isNotEmpty ? hintTextHarga : 'harga',
                    ),
                    controller: hrgbrng,
                  ),
                  TextFormField(
                    onChanged: (value) {},
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
                  ElevatedButton(
                    onPressed: () {
                      chooseDate();
                    },
                    child: Text('Pilih Tanggal'),
                  ),
                  inputDate != null
                      ? Text(
                          "${inputDate?.day} - ${inputDate?.month} - ${inputDate?.year}")
                      : const SizedBox(),
                  isUpdateProduct
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: inputDate == null
                              ? null
                              : () async {
                                  if (_formstate.currentState!.validate()) {
                                    setState(() {
                                      isUpdateProduct = true;
                                    });

                                    // buat function update data product

                                    if (splitvalue == 'tambahkan') {
                                      num1 = int.parse(hintTextJmlh);
                                      print('nilai $result');
                                      num2 = int.parse(jmlbrng.text);
                                      result = num1 + num2;
                                      await DataServices.brg_masuk(
                                        nameProduct: dropdownValue,
                                        productPrice: (hrgbrng.text),
                                        totalProduct: int.parse(jmlbrng.text),
                                        dateInput: inputDate!,
                                      );
                                      await DataServices.updateprduct(
                                        dropdownValue: dropdownValue,
                                        jmlbrng: result,
                                        dateInput: inputDate!,
                                      );
                                    } else if (splitvalue == 'kurangi') {
                                      num1 = int.parse(hintTextJmlh);
                                      print('nilai $result');
                                      num2 = int.parse(jmlbrng.text);
                                      result = num1 - num2;
                                      await DataServices.updateprduct(
                                        dropdownValue: dropdownValue,
                                        jmlbrng: int.parse(result.toString()),
                                        dateInput: inputDate!,
                                      );
                                      await DataServices.brg_keluar(
                                        nameProduct: dropdownValue,
                                        productPrice: (hrgbrng.text),
                                        totalProduct: int.parse(jmlbrng.text),
                                        dateInput: inputDate!,
                                      );
                                    }

                                    setState(() {
                                      isUpdateProduct = false;
                                    });

                                    Navigator.pushNamed(context, MainPage.path);
                                    Navigator.pushNamed(
                                        context, Productlist.path);
                                  }
                                },
                          child: Text('Update'))
                ],
              ),
            );
          }),
    );
  }

  void chooseDate() async {
    final DateTime? choosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2017),
      lastDate: DateTime(2050),
    );

    if (choosenDate != null) {
      setState(
        () {
          inputDate = choosenDate;
        },
      );
    }
  }
}

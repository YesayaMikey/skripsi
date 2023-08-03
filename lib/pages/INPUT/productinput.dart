// ignore: implementation_imports
import 'dart:io';

import 'package:app_skripsi/service/data_services.dart';
import 'package:app_skripsi/service/upload_service.dart';
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class ProductInput extends StatefulWidget {
  const ProductInput({super.key});
  static String path = "/productinput";

  @override
  State<ProductInput> createState() => _ProductInputState();
}

class _ProductInputState extends State<ProductInput> {
  TextEditingController ctrlnmbarang = TextEditingController();
  TextEditingController ctrlhrgbarang = TextEditingController();
  TextEditingController ctrljmlhbarang = TextEditingController();
  String dropdownValue = "pilih";
  String imagePreview = "";
  DateTime? inputDate;
  bool isUploadNewProduct = false;
  final _formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 136, 0),
        title: Text(''),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: _formstate,
          child: ListView(
            children: [
              TextFormField(
                // ignore: body_might_complete_normally_nullable
                validator: (value) {
                  if (value == '') {
                    return "wajib isi";
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Nama barang',
                  border: OutlineInputBorder(),
                ),
                controller: ctrlnmbarang,
                onChanged: (value) {
                  // ignore: unused_label
                  validator:
                  (value) {
                    if (value == '') {
                      return "wajib isi";
                    }
                  };
                },
              ),
              TextFormField(
                // ignore: body_might_complete_normally_nullable
                validator: (value) {
                  if (value == '') {
                    return "wajib isi";
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Harga barang',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: ctrlhrgbarang,
              ),
              TextFormField(
                // ignore: body_might_complete_normally_nullable
                validator: (value) {
                  if (value == '') {
                    return "wajib isi";
                  }
                },
                decoration: InputDecoration(
                  hintText: 'jumlah barang',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                controller: ctrljmlhbarang,
              ),
              // DropdownButton<String>(
              //     value: dropdownValue,
              //     items: [
              //       DropdownMenuItem(
              //         value: "pilih",
              //         child: Text("pilih"),
              //       ),
              //       DropdownMenuItem(
              //         value: "kurangi",
              //         child: Text("kurangi"),
              //       ),
              //       DropdownMenuItem(
              //         value: "tambahkan",
              //         child: Text("tambahkan"),
              //       ),
              //     ],
              //     onChanged: (String? value) {
              //       debugPrint("apa ya yang dipilih? $value");
              //       // This is called when the user selects an item.
              //       setState(() {
              //         dropdownValue = value!;
              //       });
              //     }),
              ElevatedButton(
                onPressed: () {
                  pickGalleryImage();
                },
                child: Text('foto'),
              ),
              // show image
              imagePreview.isNotEmpty
                  ? Image.file(
                      File(imagePreview),
                      width: 250,
                      fit: BoxFit.contain,
                    )
                  : const SizedBox(),
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
              isUploadNewProduct
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formstate.currentState!.validate()) {
                          setState(() {
                            isUploadNewProduct = true;
                          });

                          final String imageUploaded = await UploadService()
                              .uploadFile(pathFile: imagePreview);

                          // buat function submit data product
                          await DataServices.addProduct(
                            nameProduct: ctrlnmbarang.text,
                            productPrice: ctrlhrgbarang.text,
                            totalProduct: int.parse(ctrljmlhbarang.text),
                            dateInput: inputDate!,
                            imageUploadedPath: imageUploaded,
                          );
                          null;

                          setState(() {
                            isUploadNewProduct = false;
                          });

                          Navigator.pop(context);
                        }
                      },
                      child: Text('submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void pickGalleryImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      debugPrint("ada image ga? ${image.path}");
      setState(() {
        imagePreview = image.path;
      });
    }
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

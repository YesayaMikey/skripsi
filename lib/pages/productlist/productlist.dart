import 'package:app_skripsi/pages/INPUT/jurnalinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Productlist extends StatefulWidget {
  const Productlist({super.key});
  static String path = "/productlist";

  @override
  State<Productlist> createState() => _ProductlistState();
}

class _ProductlistState extends State<Productlist> {
  // documentId
  List<String> docIDs = [];

  // get docID
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDocId() async {
    return await FirebaseFirestore.instance
        // QUERY DI COLLLECTION PAKAI WHERE
        .collection('products')
        .orderBy('date_input', descending: true)
        .get()
        .then((snapshot) => snapshot.docs);
  }

  @override
  void initState() {
    getDocId();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => jurnal(
                            selectProduct: "",
                          )));
            },
            icon: Icon(
              Icons.content_paste_search_rounded,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getDocId(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            // print("dataaaa $data");
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final product = data[index].data();
                // print("data apa ya? ${product}");
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => jurnal(
                                  selectProduct: product['product_name'],
                                )));
                  },
                  child: Productlistwidget(
                    productTitle: product['product_name'],
                    price: product['product_price'],
                    imagePath: product['image_path'],
                    stok: product['total_product'],
                  ),
                );
              },
              padding: EdgeInsets.all(30),
            );
          }
          return Center(
            child: Text("Data tidak ada"),
          );
        },
      ),
    );
  }
}

class Productlistwidget extends StatelessWidget {
  const Productlistwidget({
    super.key,
    required this.imagePath,
    required this.productTitle,
    // required this.desc,
    required this.stok,
    required this.price,
  });

  final String imagePath;
  final String productTitle;
  // final String desc;
  final int stok;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // gambar
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 5,
              color: Color.fromARGB(255, 255, 71, 20),
            ),
          ),
          child: Image.network(
            imagePath,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 30),
        // deskripsi
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productTitle,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
              ),
              // Text('detail barang'),
              Text('stok :' + stok.toString()),
              Text(
                'harga :' + price,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ],
          ),
        )
      ],
    );
  }
}

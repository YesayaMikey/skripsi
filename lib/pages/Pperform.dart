import 'package:app_skripsi/service/data_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pperform extends StatefulWidget {
  const Pperform({super.key});
  static String path = "/Pperform";

  @override
  State<Pperform> createState() => _PperformState();
}

class _PperformState extends State<Pperform> {
  Map<String, int> fieldValueSums = {};
  Map<String, int> fieldValueSumsin = {}; // Use int type here
  String highestSumProduct =
      ''; // To store the product name with the highest sum
  String highestSumProductImageUrl =
      ''; // To store the image URL of the highest sum product
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    _calculateSums();
  }

  Future<void> _calculateSums() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        await DataServices.docjmlh();

    fieldValueSums.clear(); // Clear the map before calculating

    for (var doc in docs) {
      String fieldName = 'product_name';
      String fieldValue = doc[fieldName] as String;

      String totalFieldName = 'total_product';
      int totalFieldValue = (doc[totalFieldName] as num).toInt();

      fieldValueSums[fieldValue] =
          (fieldValueSums[fieldValue] ?? 0) + totalFieldValue;
    }

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> docsin =
        await DataServices.docjmlhmasuk();

    fieldValueSumsin.clear(); // Clear the map before calculating

    for (var doc in docsin) {
      String fieldName = 'product_name';
      String fieldValue = doc[fieldName] as String;

      String totalFieldName = 'total_product';
      int totalFieldValue = (doc[totalFieldName] as num).toInt();

      fieldValueSumsin[fieldValue] =
          (fieldValueSumsin[fieldValue] ?? 0) + totalFieldValue;
    }

    // Find the product with the highest sum
    String productWithHighestSum = fieldValueSums.entries
        .reduce((prev, entry) => entry.value > prev.value ? entry : prev)
        .key;

    // Fetch image URL for the highest sum product
    String imageUrl = await DataServices.fetchImageUrl(productWithHighestSum);

    // Update the UI after calculating sums
    setState(() {
      highestSumProduct = productWithHighestSum;
      highestSumProductImageUrl = imageUrl;
      isLoading = false; // Set loading state to false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Performance'),
        backgroundColor: Colors.orange,
      ),
      body: isLoading // Check if data is loading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Display the calculated sums using Column
                          Column(
                            children: [
                              Padding(padding: EdgeInsets.all(30.0)),
                              Column(
                                children: [
                                  Image.network(
                                    highestSumProductImageUrl,
                                    width: 100, // Adjust the width as needed
                                    height: 100, // Adjust the height as needed
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      'BEST SELLING PRODUCT OF THE MONTH: $highestSumProduct',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      '$highestSumProduct',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(30.0)),
                              SizedBox(
                                width: 150,
                                child: Column(
                                  children: [
                                    Text(
                                      'PRODUCT SELLING REPORT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          fieldValueSums.entries.map((entry) {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  entry.key,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    '${entry.value}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10.0)),
                          Column(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'PRODUCT BUYING REPORT:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      fieldValueSumsin.entries.map((entry) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${entry.value}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

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
  Map<String, int> fieldValueSums = {}; // Use int type here

  @override
  void initState() {
    super.initState();
    _calculateSums();
  }

  Future<void> _calculateSums() async {
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

    // Update the UI after calculating sums
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Performance'),
        backgroundColor: Colors.orange,
      ),
      body: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Product Performance Sums:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Display the calculated sums using Column
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: fieldValueSums.entries.map((entry) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${entry.value}',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadService {
  final _firebaseStorage = FirebaseStorage.instance;
  Future<String> uploadFile({required String pathFile}) async {
    final File fileToUpload = File(
        pathFile); //convert biar dalam bentuk file yang bisa dipahami oleh program/flutter

    // kalau filenya ada/ ada pilih file
    if (pathFile.isNotEmpty) {
      //Upload to Firebase
      final snapshot = await _firebaseStorage
          .ref()
          .child('images/$pathFile')
          .putFile(fileToUpload);

      // dapat file url
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      debugPrint('No File Path Received');
      return '';
    }
  }
}

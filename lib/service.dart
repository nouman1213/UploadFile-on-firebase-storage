import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class fbStorage {
  static UploadTask? uploadfile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print("Error Occured");
      print(e);
      return null;
    }
  }
}

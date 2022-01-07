import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
class StorageService{

  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
  String?  _url;
  Future<String?> uploadUserPhoto(String username, File image) async {

    Reference _storageReference=_firebaseStorage.ref().child("users").child(username).child("profile_photo.png");
    UploadTask _uploadTask= _storageReference.putFile(image,);

    await _uploadTask.whenComplete(() async {
      _url =await  _storageReference.getDownloadURL();
      print("IMAGE URL  ---> "+_url!);
    });
    return _url;
  }

  Future<String?> uploadProductPhoto(String barcode, File image) async {

    Reference _storageReference=_firebaseStorage.ref().child("products").child(barcode).child("product_photo.png");
    UploadTask _uploadTask= _storageReference.putFile(image,);

    await _uploadTask.whenComplete(() async {
      _url =await  _storageReference.getDownloadURL();
      print("IMAGE URL  ---> "+_url!);
    });
    return _url;
  }

}
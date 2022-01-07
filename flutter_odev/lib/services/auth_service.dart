import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_odev/bases/hive_base.dart';
import 'package:flutter_odev/bases/user_base.dart';
import 'package:flutter_odev/consts/consts.dart';
import 'package:flutter_odev/services/storage_service.dart';
import 'package:hive/hive.dart';

class AuthService {
  StorageService _storageService = StorageService();
  final _fireStore = FirebaseFirestore.instance;
  User? _user;
  DocumentSnapshot<Map<String, dynamic>>? _documentSnap;
  QuerySnapshot<Map<String, dynamic>>? _querySnap;
  late HiveUser _hiveUser;
  Box<HiveUser> _authUserBox = Hive.box<HiveUser>(localDB);

  Future<User?> login(String username, password) async {
    try {
      _documentSnap = await _fireStore.collection("users").doc(username).get();

      if (_documentSnap!.exists) {
        _user = User.fromMap(_documentSnap!.data()!);
        if (_user!.password == password) {
          _hiveUser = HiveUser(
              username: _user!.username,
              profileUrl: _user!.profileUrl,
              password: _user!.password);
          await _authUserBox.put(localDB, _hiveUser);
          return _user;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      print(e.code + " ${e.message}");
      return null;
    }
  }

  Future<User?> signUp(String username, password, File image) async {
    try {
      _querySnap = await _fireStore
          .collection("users")
          .where("username", isEqualTo: username)
          .get();
      if (_querySnap!.docs.isEmpty) {
        String? url =
            await _storageService.uploadUserPhoto(username, image);

        _user = User(
          profileUrl: url!,
          username: username,
          password: password,
          products: null,
        );

        await _fireStore.collection("users").doc(username).set(_user!.toMap());
        _hiveUser = HiveUser(
          username: _user!.username,
          profileUrl: _user!.profileUrl,
          password: _user!.password,
        );
        await _authUserBox.put(localDB, _hiveUser);
        return _user;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      print(e.code + " ${e.message}");
    }
  }

  Future<void> logout()async{
    await _authUserBox.clear();
  }
}

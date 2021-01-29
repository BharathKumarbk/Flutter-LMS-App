import 'package:merit_coaching_app1/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/foundation.dart';
import 'package:merit_coaching_app1/services/firebase_course_logic.dart';
import 'package:uuid/uuid.dart';

class FirebaseUserService extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future addUser(
      FirebaseAppUser appUser, String id, FirebaseCourseLogic logic) async {
    DocumentReference documentReference = firebaseFirestore
        .collection("School")
        .doc("User Id")
        .collection("Users")
        .doc(id);

    try {
      await documentReference.set(appUser.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<FirebaseAppUser> getSingleUserData(String id) async {
    try {
      return await firebaseFirestore
          .collection("School")
          .doc("User Id")
          .collection("Users")
          .doc(id)
          .get()
          .then((value) => FirebaseAppUser.fromMap(value));
    } catch (e) {
      return null;
    }
  }

  Future updateFirstUserData(String uid) async {
    try {
      return await firebaseFirestore
          .collection("School")
          .doc("User Id")
          .collection("Users")
          .doc(uid)
          .update({
        "firstUser": "false",
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<FirebaseAppUser> getSingleUser(String id) {
    try {
      return firebaseFirestore
          .collection("School")
          .doc("User Id")
          .collection("Users")
          .doc(id)
          .snapshots()
          .map((event) => FirebaseAppUser.fromMap(event));
    } catch (e) {
      return null;
    }
  }

  Stream<FirebaseAppUser> getStreamUser(String id) {
    try {
      return firebaseFirestore
          .collection("School")
          .doc("User Id")
          .collection("Users")
          .doc(id)
          .snapshots()
          .map((event) => FirebaseAppUser.fromMap(event));
    } catch (e) {
      return null;
    }
  }
}

class StorageRepo extends ChangeNotifier {
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final uid = Uuid().v4();
  Future<String> uploadFile(File file) async {
    try {
      var storageRef = _storage.ref().child("user/profile/$uid");
      var uploadTask = storageRef.putFile(file);
      var completedTask = await uploadTask.whenComplete(() {});
      String downloadUrl = await completedTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<String> getUserProfileImage(String uid) async {
    return await _storage.ref().child("user/profile/$uid").getDownloadURL();
  }

  Future deleteImage(String url) async {
    firebase_storage.Reference ref = _storage.refFromURL(url);
    await ref.delete();
  }
}

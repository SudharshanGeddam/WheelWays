import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wheelways/models/user_model.dart';

class UserService {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentReference docRef = db.collection('users').doc(uid);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        return UserModel.fromMap(uid, snapshot.data() as Map<String,dynamic>);
      }
    } catch (e) {
      debugPrint('Error in fetching User details $e');
    }
    return null;
  }
}
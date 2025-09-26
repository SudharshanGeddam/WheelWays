import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheelways/models/user_provider.dart';

class GetUsersDetails {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getUserDetails(WidgetRef ref) async {
    try {
      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid;
        DocumentReference docRef = db.collection('users').doc(uid);
        DocumentSnapshot snapshot = await docRef.get();
        if (snapshot.exists) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          ref.read(userProvider.notifier).state = UserProvider(
            name: userData['employeeName'],
            email: userData['email'],
            role: userData['role'],
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

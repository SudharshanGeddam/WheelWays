import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserProvider {
  final String? name;
  final String? email;
  final String? role;

  UserProvider({
    required this.name,
    required this.email,
    required this.role});

}
final userProvider = FutureProvider<UserProvider?>((ref) async {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  final user = auth.currentUser;
  if (user == null) return null;

  final snapshot = await db.collection('users').doc(user.uid).get();
  if (!snapshot.exists) return null;

  final data = snapshot.data()!;
  return UserProvider(
    name: data['employeeName'],
    email: data['email'],
    role: data['role'],
  );
});
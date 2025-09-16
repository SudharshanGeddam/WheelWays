import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelways/widgets/paginated_list_screen_available_bikes.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userName;
  Future<void> getCurrentUserId() async {
    try {
      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid;
        DocumentReference docRef = db.collection('users').doc(uid);
        DocumentSnapshot snapshot = await docRef.get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          setState(() => userName = data['employeeName']);
          print(userName);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wheel Ways'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (userName != null)
                ? Text('Hello $userName! Welcome.')
                : Text('Hello User! Welcome.'),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Lottie.asset(
                        'assets/lotties/Bycicle delivery fast.json',
                      ),
                    ),
                    const Text('Ride Safe, Ride with Caution'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: PaginatedListScreenAvailableBikes()),
          ],
        ),
      ),
    );
  }
}

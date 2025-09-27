import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheelways/wrapper/user_wrapper.dart';

class ProfilePage extends ConsumerStatefulWidget{
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late final TextEditingController phoneNoController;
  late final TextEditingController employeeIdController;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth  = FirebaseAuth.instance;

  Future<void> saveUserDetails(String phoneNo, String employeeId) async {
    try{
      String uid = _auth.currentUser!.uid;
      await db.collection('users').doc(uid).set({
        'phoneNo': phoneNo,
        'employeeId':employeeId,
      });
    } catch(e){
      debugPrint('Failed to store details $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserAsyncWrapper(builder: (context, user){
      final userName = user.name ?? '';
      final userRole = user.role ?? '';
      final userEmail = user.email ?? '';
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.purple,
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: TextEditingController(text: userName),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: TextEditingController(text: userEmail),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: TextEditingController(text: userRole),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Role',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          TextField(
            controller: phoneNoController,
            decoration: InputDecoration(
              labelText: 'Phone.No',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),  
          TextField(
            controller: employeeIdController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Employee_Id',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),   
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () => saveUserDetails(phoneNoController.text.trim(), employeeIdController.text.trim()),
              child: Text('Save'),),
          )
        ],
      ),),
    );
    }
    );
  }
}
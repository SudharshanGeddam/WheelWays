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
 final  phoneNoController = TextEditingController();
 final  employeeIdController = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth  = FirebaseAuth.instance;

  Future<void> saveUserDetails(String phoneNo, String employeeId) async {
    try{
      String uid = _auth.currentUser!.uid;
      await db.collection('users').doc(uid).set({
        'phoneNo': phoneNo,
        'employeeId':employeeId,
      },
      SetOptions(merge: true)
      );
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Added Successfully.')));
    } catch(e){
      debugPrint('Failed to store details $e');
    }
  }

  @override
  void dispose() 
  {
    super.dispose();
    phoneNoController.dispose();
    employeeIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserAsyncWrapper(builder: (context, user){
      final userName = user.name ?? '';
      final userRole = user.role ?? '';
      final userEmail = user.email ?? '';
    return  Padding(padding: EdgeInsets.all(16.0),
      child: Column(
        
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/images/profile_picture.png'),
          ),
          const SizedBox(height: 50,),
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
          const SizedBox(height: 20,),
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
          const SizedBox(height: 20,),
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
          const SizedBox(height: 20,),
          TextField(
            controller: phoneNoController,
            decoration: InputDecoration(
              labelText: 'Phone.No',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),  
          const SizedBox(height: 20,),
          TextField(
            controller: employeeIdController,
            decoration: InputDecoration(
              labelText: 'Employee_Id',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),   
          const SizedBox(height: 20,),
          Align(
            alignment: Alignment.bottomRight,
            child: FilledButton(
              onPressed: () => saveUserDetails(phoneNoController.text.trim(), employeeIdController.text.trim()),
              child: Text('Update'),),
          )
        ],
      ),
    );
    }
    );
  }
}
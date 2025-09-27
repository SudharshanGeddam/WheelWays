import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheelways/wrapper/user_wrapper.dart';

class ProfilePage extends ConsumerStatefulWidget{
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
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
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: TextEditingController(text: userEmail),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: TextEditingController(text: userRole),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Role',
              border: OutlineInputBorder(),
            ),
          ),
          
        ],
      ),),
    );
    }
    );
  }
}
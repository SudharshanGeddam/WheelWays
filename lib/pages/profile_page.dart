import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final phoneNoController = TextEditingController();
  final employeeIdController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    final uid = _auth.currentUser!.uid;
    final doc = await db.collection('users').doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        phoneNoController.text = data['phoneNo'] ?? '';
        employeeIdController.text = data['employeeId'] ?? '';
        nameController.text = data['employeeName'] ?? '';
        emailController.text = data['email'] ?? '';
        roleController.text = data['role'] ?? '';
      });
    }
  }

  Future<void> saveUserDetails(String phoneNo, String employeeId) async {
    try {
      final uid = _auth.currentUser!.uid;
      await db.collection('users').doc(uid).set({
        'phoneNo': phoneNo,
        'employeeId': employeeId,
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Updated Successfully.')),
      );
    } catch (e) {
      debugPrint('Failed to store details $e');
    }
  }

  @override
  void dispose() {
    phoneNoController.dispose();
    employeeIdController.dispose();
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/profile_picture.png'),
            ),
            const SizedBox(height: 50),
            _buildReadOnlyField('Name', nameController),
            const SizedBox(height: 20),
            _buildReadOnlyField('Email', emailController),
            const SizedBox(height: 20),
            _buildReadOnlyField('Role', roleController),
            const SizedBox(height: 20),
            _buildEditableField('Phone No', phoneNoController),
            const SizedBox(height: 20),
            _buildEditableField('Employee ID', employeeIdController),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: FilledButton(
                onPressed: () => saveUserDetails(
                  phoneNoController.text.trim(),
                  employeeIdController.text.trim(),
                ),
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}

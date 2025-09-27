import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<RegisterScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isLoading = false;
  bool isUserCreated = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String get empName => _nameController.text.trim();
  String get role => _roleController.text.trim();
  String get email => _emailController.text.trim();

  Future<void> createUserWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      if (!_formKey.currentState!.validate()) return;
      setState(() => isLoading = true);
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      String uid = credential.user!.uid;
      setState(() => isLoading = false);
      if (!mounted) return;
      isUserCreated = true;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registeration Successful.')));
      if (isUserCreated) {
        storeUserDetails(uid, empName, role, email);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;

      final message = (e.code == 'weak-password')
          ? 'Password is too weak'
          : (e.code == 'email-already-in-use')
          ? 'User already exists.'
          : 'Registeration Failed';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> storeUserDetails(
    String uid,
    String empName,
    String role,
    String email,
  ) async {
    try {
      await db.collection('users').doc(uid).set({
        'employeeName': empName,
        'role': role,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error in registering user.');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/login-bg.png', fit: BoxFit.cover),
          ),
          Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'REGISTER',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Please fill all the fields',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          label: Text('Employee Name'),
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.person_2_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Name required' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _roleController,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          label: Text('Role'),
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Role required' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: Text('Email'),
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Email required' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        textCapitalization: TextCapitalization.none,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text('Password'),
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.password_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Password required' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _confirmPasswordController,
                        textCapitalization: TextCapitalization.none,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text('Confirm Password'),
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.password_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value != _passwordController.text.trim()
                            ? 'Password do not match'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            !isLoading
                                ? createUserWithEmailAndPassword(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  )
                                : null;
                          },
                          child: isLoading
                              ? SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Lottie.asset(
                                    'assets/lotties/Loading.json',
                                  ),
                                )
                              : Text(
                                  'Register',
                                  style: GoogleFonts.montserrat(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

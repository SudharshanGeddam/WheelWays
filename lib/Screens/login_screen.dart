import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelways/Screens/register_screen.dart';
import 'package:wheelways/pages/admin_home.dart';
import 'package:wheelways/pages/employee_home.dart';
import 'package:wheelways/pages/security_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isLoading = false;
  bool isLogin = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      if (!_formKey.currentState!.validate()) return;
      setState(() {
        isLoading = true;
      });
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      setState(() {
        isLoading = false;
        isLogin = true;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Successful.')));
        String uid = credential.user!.uid;
        if (isLogin) {
          getUserRole(uid);
        }
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User not registered.')));
        setState(() {
          isLoading = false;
        });
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please check your password and try again.')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong')));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getUserRole(String uid) async {
    try {
      DocumentReference docRef = db.collection('users').doc(uid);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String role = data['role'];
        if (!mounted) return;
        if (role == 'Admin' || role == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminHome()),
          );
        } else if (role == 'Employee' || role == 'employee') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployeeHome()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecurityHome()),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
                        "LOGIN",
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "Please fill the details to get started.",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: Text("Email"),
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter email.' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        textCapitalization: TextCapitalization.none,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text("Password"),
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter password.' : null,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            !isLoading
                                ? signInWithEmailAndPassword(
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
                                  "Login",
                                  style: GoogleFonts.montserrat(
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Don't have an account? Signup",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Divider(color: Colors.black),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "or continue with",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/google.jpg",
                                height: 20,
                              ),
                              label: Text(
                                "Google",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/facebook.png",
                                height: 20,
                              ),
                              label: Text(
                                "Facebook",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
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

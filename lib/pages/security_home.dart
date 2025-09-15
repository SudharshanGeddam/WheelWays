import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecurityHome extends StatefulWidget {
  const SecurityHome({super.key});

  @override
  State<SecurityHome> createState() => _SecurityHomeState();
}

class _SecurityHomeState extends State<SecurityHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _bikeLocation = TextEditingController();
  List<String> selectedColor = ['Red', 'Blue', 'Black', 'Green'];
  String? choosenColor;
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

  Future<void> storeBikeDetails(
    String bikeId,
    String bikeColor,
    String location,
  ) async {
    try {
      final DocumentReference bikeRef = db.collection('BikesData').doc(bikeId);
      final DocumentSnapshot bikeSnapshot = await bikeRef.get();
      if (!mounted) return;
      if (bikeSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bike with this ID already exists.')),
        );
      } else {
        await db.collection('BikesData').doc(bikeId).set({
          'bikeId': bikeId,
          'bikeColor': bikeColor,
          'bikeLocation': location,
          'isAllocated': false,
          'isDamaged': false,
          'allocatedTo': '',
          'returnBy': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bike added Successfully')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _bikeLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wheel Ways'), centerTitle: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (userName != null)
                  ? Text('Hello $userName! Welcome.')
                  : Text('Hello User! Welcome.'),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color.fromARGB(255, 188, 222, 250),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 238, 233, 233),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _idController,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) =>
                            value!.isEmpty ? 'Id required' : null,
                        decoration: InputDecoration(
                          label: Text('Bike Id'),
                          prefixIcon: Icon(Icons.add_circle_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          label: Text('Choose color'),
                          prefixIcon: Icon(Icons.color_lens_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        initialValue: choosenColor,
                        items: selectedColor.map((val) {
                          return DropdownMenuItem(value: val, child: Text(val));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            choosenColor = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please choose a color' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _bikeLocation,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) =>
                            value!.isEmpty ? 'Mention Location' : null,
                        decoration: InputDecoration(
                          label: Text('Bike Location'),
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              storeBikeDetails(
                                _idController.text.trim(),
                                choosenColor!,
                                _bikeLocation.text.trim(),
                              );

                              setState(() {
                                choosenColor = null;
                                _idController.clear();
                                _bikeLocation.clear();
                              });
                            }
                          },
                          child: Text('Add Bike'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Chip(label: Text('Available Bikes')),
                    const SizedBox(width: 10),
                    Chip(label: Text('Bike Allocated')),
                    const SizedBox(width: 10),
                    Chip(label: Text('Return Requests')),
                    const SizedBox(width: 10),
                    Chip(label: Text('Damaged')),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

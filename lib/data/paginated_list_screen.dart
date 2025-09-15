import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelways/pages/request_page.dart';

class PaginatedListScreen extends StatefulWidget {
  const PaginatedListScreen({super.key});

  @override
  State<PaginatedListScreen> createState() => _PaginatedListScreenState();
}

class _PaginatedListScreenState extends State<PaginatedListScreen> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userName;
  final int _limit = 10;

  List<DocumentSnapshot> bikes = [];
  DocumentSnapshot? lastDoc;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchBikes();
    _getCurrentUserId();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMore) {
        _fetchBikes();
      }
    });
  }

  Future<void> _getCurrentUserId() async {
    try {
      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid;
        DocumentReference docRef = db.collection('users').doc(uid);
        DocumentSnapshot snapshot = await docRef.get();
        if (snapshot.exists) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          setState(() => userName = userData['employeeName']);

          print(userName);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchBikes() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      Query query = db
          .collection('BikesData')
          .orderBy('createdAt', descending: true)
          .where('isAllocated', isEqualTo: false)
          .where('isDamaged', isEqualTo: false)
          .limit(_limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDoc = querySnapshot.docs.last;
        setState(() {
          bikes.addAll(querySnapshot.docs);
        });

        if (querySnapshot.docs.length < _limit) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: bikes.length + 1,
      itemBuilder: (context, index) {
        if (index < bikes.length) {
          var data = bikes[index].data() as Map<String, dynamic>;
          return Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/bike_img.jpg',
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      const Text('HCL Bikes'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text('Color: ${data['bikeColor']}'),
                  const SizedBox(height: 5),
                  Text('Bike Id: ${data['bikeId']}'),
                  const SizedBox(height: 5),
                  Text('Location: ${data['bikeLocation']}'),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await db
                              .collection('BikesData')
                              .doc(bikes[index].id)
                              .update({
                                'isAllocated': true,
                                'allocatedTo': userName,
                              });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestPage(
                                bikeId: data['bikeId'],
                                bikeColor: data['bikeColor'],
                                bikeLocation: data['bikeLocation'],
                                allocatedTo: userName!,
                              ),
                            ),
                          );
                        } catch (e) {
                          print('Update failed');
                        }
                      },
                      child: Text('Request'),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return hasMore
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Lottie.asset(
                      'assets/lotties/Loading.json',
                      width: 250,
                      height: 250,
                    ),
                  ),
                )
              : SizedBox();
        }
      },
    );
  }
}

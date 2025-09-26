import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FetchAllocatedBikes {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final int _limit = 10;
  List<DocumentSnapshot> bikes = [];
  DocumentSnapshot? lastDoc;
  bool hasMore = true;

  Future<void> fetchAllocatedBikes() async {
    try {
      Query query = db
          .collection('BikesData')
          .where('isAllocated', isEqualTo: true)
          .limit(_limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDoc = querySnapshot.docs.last;

        bikes.addAll(querySnapshot.docs);

        if (querySnapshot.docs.length < _limit) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
     debugPrint('Error in fetching Allocated Bikes.');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class BikesDashboardService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<Map<String, int>> bikeStatusStream() {
    return db.collection('BikesData').snapshots().map((snapshot){
      int available = 0, allocated = 0, returned = 0, damaged = 0;

      for(var doc in snapshot.docs) {
        final data = doc.data();

        if(data['isDamaged'] == true){
          damaged++;
        } else if(data['isAllocated'] == true){
          allocated++;
        } else if(data['isReturned'] == true) {
          returned++;
        } else {
          available++;
        }
      }

      return {
        'available': available,
        'allocated': allocated,
        'damaged' : damaged,
        'returned': returned,
      };
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchDamagedBikes {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _limit = 10;
  List<DocumentSnapshot> bikes = [];
  DocumentSnapshot? lastDoc;
  bool hasMore = true;

  Future<void> fetchDamagedBikes() async {
    try{
      Query query = db.collection('BikesData')
      .where('isDamaged', isEqualTo: true)
      .limit(_limit);

      if(lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if(querySnapshot.docs.isNotEmpty){
        lastDoc = querySnapshot.docs.last;

        bikes.addAll(querySnapshot.docs);
        if(querySnapshot.docs.length < _limit){
          hasMore = false;
        }
      } else {
        hasMore = false;
      }

    } catch(e)
    {
      print(e);
    }
  }
}
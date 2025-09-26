import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelways/models/fetch_available_bikes.dart';
import 'package:wheelways/models/user_provider.dart';
import 'package:wheelways/pages/request_page.dart';

class PaginatedListScreenAvailableBikes extends ConsumerStatefulWidget {
  const PaginatedListScreenAvailableBikes({super.key});

  @override
  ConsumerState<PaginatedListScreenAvailableBikes> createState() =>
      _PaginatedListScreenState();
}

class _PaginatedListScreenState
    extends ConsumerState<PaginatedListScreenAvailableBikes> {
  late final Fetchavailablebikes fetchavailablebikes;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchavailablebikes = Fetchavailablebikes();
    _loadMoreBikes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          fetchavailablebikes.hasMore) {
        _loadMoreBikes();
      }
    });
  }

  Future<void> _loadMoreBikes() async {
    if (isLoading || !fetchavailablebikes.hasMore) return;
    setState(() {
      isLoading = true;
    });
    await fetchavailablebikes.fetchAvailbleBikes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProviderValue = ref.watch(userProvider);
    final userName = userProviderValue?.name ?? '';
    return ListView.builder(
      controller: _scrollController,
      itemCount: fetchavailablebikes.bikes.length + 1,
      itemBuilder: (context, index) {
        if (index < fetchavailablebikes.bikes.length) {
          var data =
              fetchavailablebikes.bikes[index].data() as Map<String, dynamic>;
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
                              .doc(fetchavailablebikes.bikes[index].id)
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
                                allocatedTo: userName,
                              ),
                            ),
                          );
                        } catch (e) {
                          debugPrint('Error in updating allocated bikes.');
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
          return isLoading
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Lottie.asset(
                      'assets/lotties/Loading.json',
                      width: 100,
                      height: 100,
                    ),
                  ),
                )
              : SizedBox();
        }
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'package:wheelways/models/fetch_damaged_bikes.dart';
import 'package:wheelways/models/user_provider.dart';

class PaginatedListScreenDamagedBikes extends ConsumerStatefulWidget {
  const PaginatedListScreenDamagedBikes({super.key});

  @override
  ConsumerState<PaginatedListScreenDamagedBikes> createState() =>
      _PaginatedListScreenState();
}

class _PaginatedListScreenState
    extends ConsumerState<PaginatedListScreenDamagedBikes> {
  late final FetchDamagedBikes fetchDamagedBikes;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDamagedBikes = FetchDamagedBikes();
    _loadMoreBikes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          fetchDamagedBikes.hasMore) {
        _loadMoreBikes();
      }
    });
  }

  Future<void> _loadMoreBikes() async {
    if (isLoading || !fetchDamagedBikes.hasMore) return;
    setState(() {
      isLoading = true;
    });
    await fetchDamagedBikes.fetchDamagedBikes();
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
      itemCount: fetchDamagedBikes.bikes.length + 1,
      itemBuilder: (context, index) {
        if (index < fetchDamagedBikes.bikes.length) {
          var data =
              fetchDamagedBikes.bikes[index].data() as Map<String, dynamic>;
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
                  Text('DamagedBy: $userName'),
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
                              .doc(fetchDamagedBikes.bikes[index].id)
                              .update({
                                'isAllocated': false,
                                'allocatedTo': '',
                                'isDamaged': false,
                                'isReturned': false,
                              });
                        } catch (e) {
                          debugPrint('Error in updating Damaged bikes.');
                        }
                      },
                      child: Text('Repaired'),
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

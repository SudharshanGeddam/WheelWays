import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelways/models/fetch_returned_bikes.dart';
import 'package:wheelways/wrapper/user_wrapper.dart';

class PaginatedListScreenReturnedBikes extends ConsumerStatefulWidget {
  const PaginatedListScreenReturnedBikes({super.key});

  @override
  ConsumerState<PaginatedListScreenReturnedBikes> createState() =>
      _PaginatedListScreenState();
}

class _PaginatedListScreenState
    extends ConsumerState<PaginatedListScreenReturnedBikes> {
  late final FetchReturnedBikes fetchReturnedBikes;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchReturnedBikes = FetchReturnedBikes();
    _loadMoreBikes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          fetchReturnedBikes.hasMore) {
        _loadMoreBikes();
      }
    });
  }

  Future<void> _loadMoreBikes() async {
    if (isLoading || !fetchReturnedBikes.hasMore) return;
    setState(() {
      isLoading = true;
    });
    await fetchReturnedBikes.fetchReturnBikes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserAsyncWrapper(
      builder: (context, user) {
        final userName = user.name ?? '';

        return ListView.builder(
          controller: _scrollController,
          itemCount: fetchReturnedBikes.bikes.length + 1,
          itemBuilder: (context, index) {
            if (index < fetchReturnedBikes.bikes.length) {
              var data =
                  fetchReturnedBikes.bikes[index].data()
                      as Map<String, dynamic>;
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
                      Text('ReturnedBy: $userName'),
                      const SizedBox(height: 5),
                      Text(
                        'Color: ${data['bikeColor']}',
                        style: TextTheme.of(context).bodySmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Bike Id: ${data['bikeId']}',
                        style: TextTheme.of(context).bodySmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Location: ${data['bikeLocation']}',
                        style: TextTheme.of(context).bodySmall,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await db
                                    .collection('BikesData')
                                    .doc(fetchReturnedBikes.bikes[index].id)
                                    .update({
                                      'isRetured': true,
                                      'returnedBy': userName,
                                    });
                              } catch (e) {
                                debugPrint(
                                  'Error in updating verifed returned bikes.',
                                );
                              }
                            },
                            child: Text('Return'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await db
                                    .collection('BikesData')
                                    .doc(fetchReturnedBikes.bikes[index].id)
                                    .update({
                                      'isDamaged': true,
                                      'returnedBy': userName,
                                    });
                              } catch (e) {
                                debugPrint(
                                  'Error in updating verified Damaged bikes.',
                                );
                              }
                            },
                            child: Text('Damage'),
                          ),
                        ],
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
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelways/models/fetch_allocated_bikes.dart';
import 'package:wheelways/wrapper/user_wrapper.dart';

class PaginatedListScreenAllocatedBikes extends ConsumerStatefulWidget {
  const PaginatedListScreenAllocatedBikes({super.key});

  @override
  ConsumerState<PaginatedListScreenAllocatedBikes> createState() =>
      _PaginatedListScreenState();
}

class _PaginatedListScreenState
    extends ConsumerState<PaginatedListScreenAllocatedBikes> {
  late final FetchAllocatedBikes fetchAllocatedBikes;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllocatedBikes = FetchAllocatedBikes();
    _loadMoreBikes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          fetchAllocatedBikes.hasMore) {
        _loadMoreBikes();
      }
    });
  }

  Future<void> _loadMoreBikes() async {
    if (isLoading || !fetchAllocatedBikes.hasMore) return;
    setState(() {
      isLoading = true;
    });
    await fetchAllocatedBikes.fetchAllocatedBikes();
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
          itemCount: fetchAllocatedBikes.bikes.length + 1,
          itemBuilder: (context, index) {
            if (index < fetchAllocatedBikes.bikes.length) {
              var data =
                  fetchAllocatedBikes.bikes[index].data()
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
                      const SizedBox(height: 5),
                      Text(
                        'AllocatedTo: $userName',
                        style: TextTheme.of(context).bodySmall,
                      ),
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

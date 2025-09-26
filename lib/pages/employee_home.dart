import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wheelways/models/user_provider.dart';
import 'package:wheelways/widgets/paginated_list_screen_available_bikes.dart';

class EmployeeHome extends ConsumerStatefulWidget {
  const EmployeeHome({super.key});

  @override
  ConsumerState<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends ConsumerState<EmployeeHome> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final userProviderValue = ref.watch(userProvider);
    final userName = userProviderValue?.name ?? '';
    return Scaffold(
      appBar: AppBar(title: Text('Wheel Ways'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello $userName! Welcome.'),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Lottie.asset(
                        'assets/lotties/Bycicle delivery fast.json',
                      ),
                    ),
                    const Text('Ride Safe, Ride with Caution'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: PaginatedListScreenAvailableBikes()),
          ],
        ),
      ),
    );
  }
}

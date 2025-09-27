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
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text("No user signed in"));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello ${user.name}! Welcome.'),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
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
                const Expanded(child: PaginatedListScreenAvailableBikes()),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

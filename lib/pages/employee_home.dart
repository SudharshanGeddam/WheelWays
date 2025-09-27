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
                Text(
                  'Hello ${user.name}! Welcome.',
                  style: TextTheme.of(context).titleMedium,
                ),
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
                const SizedBox(height: 50),

                Expanded(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.9,
                    minChildSize: 0.5,
                    maxChildSize: 0.95,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(blurRadius: 8, color: Colors.black26),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),

                            Expanded(
                              child: PaginatedListScreenAvailableBikes(
                                controller: scrollController,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
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

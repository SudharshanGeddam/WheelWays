import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheelways/models/user_provider.dart';

class UserAsyncWrapper extends ConsumerWidget {
  final Widget Function(BuildContext context, dynamic user) builder;

  const UserAsyncWrapper({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text("No user signed in"));
        }
        return builder(context, user);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error: $err")),
    );
  }
}

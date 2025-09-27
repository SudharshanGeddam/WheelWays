import 'package:flutter/material.dart';
import 'package:wheelways/widgets/bikes_dashboard.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BikesDashboard(),
    );
  }
}

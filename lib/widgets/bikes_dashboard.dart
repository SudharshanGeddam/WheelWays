import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wheelways/models/bikes_dashboard_service.dart';

class BikesDashboard extends StatelessWidget {
  BikesDashboard({super.key});
  final BikesDashboardService _service = BikesDashboardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bike Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<Map<String, int>>(
        stream: _service.bikeStatusStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final counts = snapshot.data!;
          counts.values.fold(0, (a, b) => a + b);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Real-time Bike Status",
          
                ),
                const SizedBox(height: 20),

                // Pie Chart
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: counts['available']?.toDouble() ?? 0,
                          color: Colors.green,
                          title: "Available",
                        ),
                        PieChartSectionData(
                          value: counts['allocated']?.toDouble() ?? 0,
                          color: Colors.blue,
                          title: "Allocated",
                        ),
                        PieChartSectionData(
                          value: counts['returned']?.toDouble() ?? 0,
                          color: Colors.orange,
                          title: "Returned",
                        ),
                        PieChartSectionData(
                          value: counts['damaged']?.toDouble() ?? 0,
                          color: Colors.red,
                          title: "Damaged",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Numeric values
                Wrap(
                  spacing: 20,
                  children: [
                    _buildStatCard("Available", counts['available']!, Colors.green),
                    _buildStatCard("Allocated", counts['allocated']!, Colors.blue),
                    _buildStatCard("Returned", counts['returned']!, Colors.orange),
                    _buildStatCard("Damaged", counts['damaged']!, Colors.red),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, int value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value.toString(), style: TextStyle(fontSize: 20, color: color)),
          ],
        ),
      ),
    );
  }
}

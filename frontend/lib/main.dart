import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String backendBaseUrl = 'http://localhost:8000';
const int defaultYear = 2024;
const int defaultMonth = 8;

void main() {
  runApp(const MaintenanceSummaryApp());
}

class MaintenanceSummaryApp extends StatelessWidget {
  const MaintenanceSummaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maintenance Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> overviewFuture;
  late Future<Map<String, dynamic>> trendsFuture;
  late Future<Map<String, dynamic>> preventativeFuture;

  @override
  void initState() {
    super.initState();
    overviewFuture = fetchStats('/stats/overview');
    trendsFuture = fetchStats('/stats/trends');
    preventativeFuture = fetchStats('/stats/preventative');
  }

  Future<Map<String, dynamic>> fetchStats(String endpoint) async {
    final url = Uri.parse('$backendBaseUrl$endpoint?year=$defaultYear&month=$defaultMonth');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load $endpoint');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Summary Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: overviewFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())));
                } else if (snapshot.hasError) {
                  return Card(color: Colors.red[100], child: ListTile(title: Text('Overview Error: \\${snapshot.error}')));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return StatTile(
                    title: 'Overview',
                    content: [
                      'Total Requests: \\${data['total_requests']}',
                      'Most Common Request: \\${data['most_common_request']} (\\${data['most_common_request_count']})',
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: trendsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())));
                } else if (snapshot.hasError) {
                  return Card(color: Colors.red[100], child: ListTile(title: Text('Trends Error: \\${snapshot.error}')));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final monthly = data['monthly_request_counts'] as Map<String, dynamic>? ?? {};
                  final growing = data['top_growing_requests'] as Map<String, dynamic>? ?? {};
                  return StatTile(
                    title: 'Trends',
                    content: [
                      if (monthly.isNotEmpty) ...[
                        'Monthly Request Volume:',
                        ...monthly.entries.map((e) => '  \\${e.key}: \\${e.value}')
                      ],
                      if (growing.isNotEmpty) ...[
                        'Top Growing Requests:',
                        ...growing.entries.map((e) => '  \\${e.key}: \\${e.value}')
                      ],
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: preventativeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())));
                } else if (snapshot.hasError) {
                  return Card(color: Colors.red[100], child: ListTile(title: Text('Preventative Error: \\${snapshot.error}')));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final candidates = data['preventative_maintenance_candidates'] as List<dynamic>? ?? [];
                  return StatTile(
                    title: 'Preventative Maintenance',
                    content: candidates.isNotEmpty
                        ? candidates.map((e) => e.toString()).toList()
                        : ['No clear candidates found.'],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String title;
  final List<String> content;
  const StatTile({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...content.map((line) => Text(line)).toList(),
          ],
        ),
      ),
    );
  }
}

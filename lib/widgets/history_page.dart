import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> history;

  const HistoryPage({required this.history, super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: widget.history.isEmpty
          ? const Center(
              child: Text(
                'No history',
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: widget.history.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      widget.history[index]['title'],
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      widget.history[index]['timestamp'].toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
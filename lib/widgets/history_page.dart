import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final String? title;
  final DateTime? timestamp;

  const HistoryPage({this.title, this.timestamp, super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _history.add({
      "title": widget.title,
      "timestamp": widget.timestamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: _history.isEmpty
          ? const Center(child: Text('No history'))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_history[index]['title']),
                  subtitle: Text(_history[index]['timestamp'].toString()),
                );
              },
            ),
    );
  }
}
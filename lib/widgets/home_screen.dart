import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_time_app/bloc/timer_bloc.dart';
import 'package:last_time_app/ticker.dart';
import 'package:last_time_app/widgets/new_schedule_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAscending = true;
  IconData _filterIcon = Icons.filter_list;

  late List<TimerBloc> _timerBlocs = [];

  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(_filterIcon),
          onPressed: () {
            setState(() {
              _isAscending = !_isAscending;
              _filterIcon =
                  _isAscending ? Icons.filter_list : Icons.filter_list_off;
              _tasks.sort((a, b) => _isAscending
                  ? a["remainingTime"].compareTo(b["remainingTime"])
                  : b["remainingTime"].compareTo(a["remainingTime"]));
            });
          },
        ),
        title: const Center(
          child: Text(
            'Last Time App Flutter',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifica', // stylish font
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.blue,
              ],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tasks.isEmpty
              ? const Center(child: Text('No tasks'))
              : Column(
                  children: _tasks.map((task) {
                    return SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.shade500.withOpacity(
                                    (task["remainingTime"] / 60).toDouble()),
                                Colors.red.shade500.withOpacity(
                                    (1 - task["remainingTime"] / 60)
                                        .toDouble()),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    task["title"],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 57, 191, 231),
                                  child: BlocBuilder<TimerBloc, TimerState>(
                                    bloc: task["timerBloc"],
                                    builder: (context, state) {
                                      if (state is TimerRunInProgress) {
                                        return AutoSizeText(
                                          state.duration.toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        return const AutoSizeText(
                                          '0',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _tasks.remove(task);
                                      _timerBlocs.remove(task["timerBloc"]);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewSchedulePage()),
                  );
                  if (result != null) {
                    final timerBloc = TimerBloc(ticker: Ticker());
                    setState(() {
                      _tasks.add({
                        "title": result["title"],
                        "remainingTime": result["remainingTime"],
                        "timerBloc": timerBloc,
                      });
                      _timerBlocs.add(timerBloc);
                    });
                    timerBloc
                        .add(TimerStarted(duration: result['remainingTime']));
                  }
                },
                child: const Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}

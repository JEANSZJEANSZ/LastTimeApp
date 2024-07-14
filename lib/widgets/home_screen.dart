import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:last_time_app/bloc/timer_bloc.dart';
import 'package:last_time_app/widgets/new_schedule_page.dart';
import 'package:last_time_app/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAscending = true;
  IconData _filterIcon = Icons.filter_list;

  late TimerBloc _timerBloc; // Get the TimerBloc instance

  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _timerBloc = context.read<TimerBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
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
          BlocBuilder<TimerBloc, TimerState>(
            buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
            builder: (context, state) {
              if (state is TimerRunInProgress) {
                // return Text('Duration: ${duration}');
                _tasks.forEach((task) {
                  task["remainingTime"] = duration;
                });
              }else {
              }
              return _tasks.isEmpty
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
                                    Colors.blue.shade50,
                                    Colors.blue.shade500,
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 137, 44, 237),
                                      child: AutoSizeText(
                                        task["remainingTime"].toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _tasks.remove(task);
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
                    );
            },
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewSchedulePage()),
                  );
                  if (result != null) {
                    setState(() {
                      _tasks.add(result);
                    });
                    _timerBloc
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

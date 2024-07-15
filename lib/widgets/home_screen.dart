import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_time_app/bloc/timer_bloc.dart';
import 'package:last_time_app/ticker.dart';
import 'package:last_time_app/widgets/history_page.dart';
import 'package:last_time_app/widgets/new_schedule_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAscending = true;
  IconData _filterIcon = Icons.filter_list;

  late final List<TimerBloc> _timerBlocs = [];

  final List<Map<String, dynamic>> _history = [];

  final List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _sortTasks();
  }

  void _sortTasks() {
    _tasks.sort((a, b) => a["remainingTime"].compareTo(b["remainingTime"]));
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
              fontFamily: 'Pacifica',
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
                    return GestureDetector(
                      onTap: () {
                        if (task['title'] != null) {
                          setState(() {
                            _history.add({
                              "title": task['title'],
                              "timestamp": DateTime.now().toString(),
                            });
                          });
                          task["timerBloc"].add(TimerReset(
                              OriginalDuration: task["remainingTime"]));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HistoryPage(history: _history),
                            ),
                          );
                        }
                      },
                      child: SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BlocBuilder<TimerBloc, TimerState>(
                            bloc: task["timerBloc"],
                            builder: (context, state) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.blue.shade500.withOpacity(
                                          (state.duration / 60)
                                              .clamp(0.0, 1.0)
                                              .toDouble()),
                                      Colors.red.shade500.withOpacity(
                                          (1 - state.duration / 60)
                                              .clamp(0.0, 1.0)
                                              .toDouble()),
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
                                        child: Text(
                                          task["title"],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 164, 231, 203),
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor:
                                            const Color.fromARGB(255, 134, 221, 185),
                                        child: Text(
                                          state.duration.toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            _tasks.remove(task);
                                            _timerBlocs
                                                .remove(task["timerBloc"]);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
                    final timerBloc = TimerBloc(ticker: const Ticker());
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
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HistoryPage(history: _history)),
              );
            },
            child: const Text('Show History'),
          )
        ],
      ),
    );
  }
}

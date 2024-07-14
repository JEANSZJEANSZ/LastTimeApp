import 'package:flutter/material.dart';
import 'package:last_time_app/bloc/timer_bloc.dart';
import 'package:last_time_app/ticker.dart';

class NewSchedulePage extends StatefulWidget {
  @override
  _NewSchedulePageState createState() => _NewSchedulePageState();
}

class _NewSchedulePageState extends State<NewSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  int _remainingTime = 0;
  late TimerBloc _timerBloc;

  @override
  void initState() {
    super.initState();
    _timerBloc = TimerBloc(ticker: Ticker());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Remaining Time'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Please enter a valid remaining time';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _remainingTime = int.parse(value);
                  } else {
                    _remainingTime = 0;
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    if (_remainingTime > 0) {
                      Navigator.pop(context, {
                        'title': _title,
                        'remainingTime': _remainingTime,
                        'timerBloc': _timerBloc
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Please enter a valid remaining time')));
                    }
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

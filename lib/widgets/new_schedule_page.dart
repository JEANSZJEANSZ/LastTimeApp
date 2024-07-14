import 'package:flutter/material.dart';

class NewSchedulePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NewSchedulePageState createState() => _NewSchedulePageState();
}

class _NewSchedulePageState extends State<NewSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  int _remainingTime = 0;

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
                onSaved: (value) => _title = value??'',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Remaining Time'),
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Please enter a valid remaining time';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null && value.isNotEmpty){
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
                      Navigator.pop(context, {'title': _title, 'remainingTime': _remainingTime});
                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid remaining')));
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_time_app/bloc/timer_bloc.dart';
import 'package:last_time_app/ticker.dart';
import 'package:last_time_app/widgets/home_screen.dart';

void main() {
  final timerBloc = TimerBloc(ticker: Ticker());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TimerBloc>(create: (_) => timerBloc),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
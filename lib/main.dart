import 'package:flutter/material.dart';
import 'package:game_scoreboard/home.dart';
import 'package:game_scoreboard/score_page_mockup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Scoreboard',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const ScorePageMockup(),
    );
  }
}

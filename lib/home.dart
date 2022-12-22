import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:game_scoreboard/score_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var availablePorts = [];

  @override
  void initState() {
    super.initState();
    availablePorts = SerialPort.availablePorts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              // refresh
              setState(() {
                availablePorts = SerialPort.availablePorts;
              });
            },
            icon: Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: Row(
        children: [
          const Expanded(
              child: Center(
            child: Text(
              'Game Scoreboard',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          )),
          Expanded(
            child: ListView(
              children: availablePorts
                  .map(
                    (port) => Card(
                      child: ListTile(
                        title: Text(port),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScorePage(comPort: port),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

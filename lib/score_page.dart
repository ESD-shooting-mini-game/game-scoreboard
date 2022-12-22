import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:google_fonts/google_fonts.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key, required this.comPort});

  final String comPort;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  late SerialPort port;
  late SerialPortReader reader;

  int playerScore = 0;

  @override
  void initState() {
    super.initState();
    port = SerialPort(widget.comPort);
    var res = port.openRead();

    if (!res) {
      print('Error opening port:${port.name}');
      // handle to close reconnet
    }
    var portConfig = SerialPortConfig()
      ..baudRate = 9600
      ..bits = 8
      ..stopBits = 1;
    port.config = portConfig;

    reader = SerialPortReader(port);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: StreamBuilder(
                stream: reader.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Awaiting result...');
                  }

                  var decoded = String.fromCharCodes(snapshot.data!);

                  // we might receive other serial messages from Serial.println, so
                  // we apply 'filtering' here
                  if (decoded.trim().contains('player scored')) {
                    playerScore++;
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Your score:', style: TextStyle(fontSize: 43)),
                      Text(
                        playerScore.toString(),
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 145,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1),
                    ),
                    onPressed: () {
                      // reset counter
                      setState(() {
                        playerScore =
                            -1; // HACK: Seems  like decoded variable is not cleared so it will add 1 to the score
                      });
                    },
                    child: const Text('Reset counter'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go back'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    port.close();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
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
  bool gameStarted = false;

  DateTime? startTime;

  DateTime? endTime;

  @override
  void initState() {
    super.initState();
    port = SerialPort(widget.comPort);
    var res = port.openRead();

    if (!res) {
      print('Error opening port:${port.name}');
      Navigator.of(context).pop();
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
      body: StreamBuilder(
          stream: reader.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          port.close();
                          Navigator.pop(context);
                        },
                        child: const Text('Go back'))
                  ],
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Awaiting result...'));
            }

            var decoded = String.fromCharCodes(snapshot.data!);

            // Check if game started
            if (decoded.trim().contains('game started')) {
              gameStarted = true;
              print('Game started');
              startTime = DateTime.now();
              endTime = DateTime.now().add(const Duration(seconds: 31));

              // reset the counter for next player
              playerScore = 0;
            }

            // we might receive other serial messages from Serial.println, so
            // we apply 'filtering' here
            if (decoded.trim().contains('player scored')) {
              if (DateTime.now().difference(startTime!).inMilliseconds > 100) {
                print('hit');
                playerScore++;
              }
            }

            // check if game ended
            if (decoded.trim().contains('game ended')) {
              gameStarted = false;
              print('Game ended');
              // reset counter
              decoded = ''; // reset the decoded buffer
            }
            return Column(children: [
              Expanded(
                  flex: 2,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Your score:', style: TextStyle(fontSize: 43)),
                      Text(
                        playerScore.toString(),
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 410,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(gameStarted ? 'Game started' : 'Game ended',
                          style: const TextStyle(fontSize: 43)),
                      CountdownTimer(
                        endTime: endTime!.millisecondsSinceEpoch,
                        endWidget:
                            Container(width: 200, height: 5, color: Colors.red),
                        textStyle: GoogleFonts.shareTechMono(
                          fontSize: 43,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // OutlinedButton(
                              //   style: OutlinedButton.styleFrom(
                              //     side: const BorderSide(
                              //         color: Colors.red, width: 1),
                              //   ),
                              //   onPressed: () {
                              //     // reset counter
                              //     setState(() {
                              //       playerScore =
                              //           -1; // HACK: Seems  like decoded variable is not cleared so it will add 1 to the score
                              //     });
                              //   },
                              //   child: const Text('Reset counter'),
                              // ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.red, width: 1),
                                ),
                                onPressed: () {
                                  port.close();
                                  Navigator.pop(context);
                                },
                                child: const Text('Go back'),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )))
            ]);
          }),
    );
  }

  @override
  void dispose() {
    port.close();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:google_fonts/google_fonts.dart';

/// Score page with mock data for screenshot purposes
class ScorePageMockup extends StatefulWidget {
  const ScorePageMockup({
    super.key,
  });

  @override
  State<ScorePageMockup> createState() => _ScorePageMockupState();
}

class _ScorePageMockupState extends State<ScorePageMockup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Highscore:  11',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  const Text('Your score:', style: TextStyle(fontSize: 43)),
                  Text(
                    '4',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 423,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Game started', style: TextStyle(fontSize: 43)),
                  CountdownTimer(
                    endTime: DateTime.now()
                        .add(const Duration(seconds: 12))
                        .millisecondsSinceEpoch,
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
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side:
                                  const BorderSide(color: Colors.red, width: 1),
                            ),
                            onPressed: () {},
                            child: const Text('Go back'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

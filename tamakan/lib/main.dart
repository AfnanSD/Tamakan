import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  late stt.SpeechToText speech;
  bool isListening = false;
  String text = 'press';
  double confidence = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Create a storage reference from our app
                  final storageRef = FirebaseStorage.instance.ref();

                  // Create a reference with an initial file path and name
                  final pathReference = storageRef.child("/practices/ألف.mp3");
                  // Create a reference to a file from a Google Cloud Storage URI
                  final gsReference = FirebaseStorage.instance.refFromURL(
                      "gs://tamakan-ef69b.appspot.com/practices/ألف.mp3");

                  print(await gsReference.getDownloadURL());
                  await player.play(
                      DeviceFileSource(await gsReference.getDownloadURL()));
                },
                child: Text('play'),
              ),
            ),
            SingleChildScrollView(
              reverse: true,
              child: Container(
                child: Text(text),
              ),
            ),
            validatePronuciation(['ا', "الف"]),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: listen,
            child: Icon(isListening ? Icons.mic : Icons.mic_none),
          ),
        ));
  }

  void listen() async {
    print('listen');
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        speech.listen(
          onResult: (val) => setState(() {
            print(val.recognizedWords + '***');
            text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => isListening = false);
      speech.stop();
    }
  }

  Widget validatePronuciation(List correctText) {
    bool found = false;
    for (var element in correctText) {
      if (text == element) found = true;
    }
    if (found)
      return Text(
        'true',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    else
      return Text(
        'false',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
  }
}

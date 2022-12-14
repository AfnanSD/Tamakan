import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
  late String recordURL;
  late List<String> correctText = List<String>.empty(growable: true);
  String id = '1'; //need to come from learnig map

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speech = stt.SpeechToText();
    geturl(id);
    getCorrectText(id);
  }

  Future geturl(String id) async {
    await FirebaseFirestore.instance
        .collection('lesson')
        .doc(id)
        .get()
        .then((value) => recordURL = value['lessonRecord']);
  }

  Future getCorrectText(String id) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('lesson')
        .doc(id)
        .collection('correctText')
        .get();
    for (var element in qs.docs) {
      correctText.add(element['text']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  //for finding refernce only  !?

                  // Create a storage reference from our app
                  final storageRef = FirebaseStorage.instance.ref();

                  // Create a reference with an initial file path and name
                  final pathReference = storageRef.child("/practices/ألف.mp3");
                  // Create a reference to a file from a Google Cloud Storage URI
                  final gsReference = FirebaseStorage.instance.refFromURL(
                      "gs://tamakan-ef69b.appspot.com/practices/ألف.mp3");

                  // print(await gsReference.getDownloadURL());
                  // await player.play(
                  //     DeviceFileSource(await gsReference.getDownloadURL()));

                  await player.play(DeviceFileSource(recordURL));
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
            validatePronuciation(correctText),
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

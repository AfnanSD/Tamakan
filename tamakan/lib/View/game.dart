import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late List<int> lessonIDs = List<int>.empty(growable: true);
  int index = 0;
  final player = AudioPlayer();
  late stt.SpeechToText speech;
  bool isListening = false;
  String text = 'press';
  double confidence = 1;
  late String recordURL;
  late List<String> correctText = List<String>.empty(growable: true);
  late String lesson = '';
  bool found = false;
  @override
  void initState() {
    super.initState();
    selectRandomLessons('7.5'); //need to come from learning map
    speech = stt.SpeechToText();
  }

  Future geturl(String id) async {
    await FirebaseFirestore.instance
        .collection('lesson')
        .doc(id)
        .get()
        .then((value) {
      setState(() {
        recordURL = value['lessonRecord'];
        lesson = value['lesson'];
      });
    });
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
      appBar: AppBar(
        title: Center(child: Text('لعبة الحروف')),
      ),
      body: practice(lessonIDs[index].toString()),
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
      ),
    );
  }

  void selectRandomLessons(String practiceID) {
    double pID = double.parse(practiceID);
    while (lessonIDs.length < 5) {
      int num = Random().nextInt(pID.ceil());
      if (!lessonIDs.contains(num) && num != 0) lessonIDs.add(num);
    }
    print(lessonIDs);
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
            print(val.recognizedWords);
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
    for (var element in correctText) {
      if (text == element) found = true;
    }
    if (found) {
      return const Text(
        'true',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    } else
      return Text(
        'false',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
  }

  Widget practice(String id) {
    geturl(lessonIDs[index].toString());
    getCorrectText(lessonIDs[index].toString());
    return Column(
      children: [
        Text(lesson),
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
            child: const Text('play'),
          ),
        ),
        SingleChildScrollView(
          reverse: true,
          child: Text(text),
        ),
        validatePronuciation(correctText),
        found
            ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    found = false;
                    text = '';
                    if ((index + 1) < lessonIDs.length) {
                      index++;
                    }
                  });
                },
                child: const Text('next'),
              )
            : Container(),
      ],
    );
  }
}

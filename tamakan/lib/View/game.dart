import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../Model/child.dart';

class Game extends StatefulWidget {
  const Game({super.key, required this.practiceID, required this.childID});

  final String practiceID;
  final String childID;

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
  bool waiting = true;
  late Child child;
  var accumelatedPoints = 0;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
  void initState() {
    super.initState();
    selectRandomLessons(widget.practiceID); //need to come from learning map
    speech = stt.SpeechToText();
    getCurrentUser();
    readChildData(widget.childID);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Image.asset(
              'assets/images/droppedlogo.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
          // title: Text('لعبة الحروف'),
          // centerTitle: true,
        ),
        body: waiting
            ? Container()
            : SingleChildScrollView(
                child: practice(
                  lessonIDs[index].toString(),
                ),
              ),
      ),
    );
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
      }
    } catch (e) {
      EasyLoading.showError("حدث خطأ ما ....");
    }
  }

  Future<void> selectRandomLessons(String practiceID) async {
    double prev = 0;
    await FirebaseFirestore.instance
        .collection('practice')
        .doc(practiceID)
        .get()
        .then((value) {
      prev = double.parse(value['prev']);
    });
    double pID = double.parse(practiceID);
    while (lessonIDs.length < 5) {
      int num = Random().nextInt(pID.ceil() - prev.ceil()) + prev.ceil();
      if (!lessonIDs.contains(num) && num != 0) lessonIDs.add(num);
    }
    print(lessonIDs);
    setState(() {
      waiting = false;
    });
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

  Future getLessonData(String id) async {
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

  Widget validatePronuciation(List correctText) {
    for (var element in correctText) {
      if (text == element) found = true;
    }
    if (found) {
      accumelatedPoints += 5;
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
    getLessonData(id);
    getCorrectText(id);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          child: gameStatusBar(), //from index
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(100),
              child: CircleAvatar(
                maxRadius: 130,
                backgroundColor: Color(0xff4ECDC4), //4ECDC4
                child: Text(
                  lesson,
                  style: TextStyle(color: Color(0xffFFE66D), fontSize: 100),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Card(
                  color: isListening ? Color(0xffF7FFF7) : Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 105, vertical: 20),
                    child: Image.asset(
                      'assets/images/mic.png',
                      scale: 1.2,
                    ),
                  ),
                ),
                onTap: listen,
              ),
              InkWell(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 105, vertical: 20),
                    child: Image.asset(
                      'assets/images/lightbulb.png',
                      scale: 1.8,
                    ),
                  ),
                ),
                onTap: () => showHintVideo(context),
              ),
            ],
          ),
        ),
        //old
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 30),
        //   child: gameStatusBar(), //from index
        // ),
        // CircleAvatar(
        //   maxRadius: 100,
        //   backgroundColor: Color(0xff4ECDC4), //4ECDC4
        //   child: Text(
        //     lesson,
        //     style: TextStyle(color: Color(0xffFFE66D), fontSize: 100),
        //   ),
        // ),
        // SizedBox(
        //   height: 50,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //       height: 50,
        //       margin: EdgeInsets.all(20),
        //       child: AvatarGlow(
        //         animate: isListening,
        //         glowColor: Theme.of(context).primaryColor,
        //         duration: const Duration(milliseconds: 2000),
        //         repeatPauseDuration: const Duration(milliseconds: 100),
        //         repeat: true,
        //         endRadius: 75.0,
        //         child: IconButton(
        //           icon: Image.asset('assets/images/mic.png'),
        //           onPressed: listen,
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        // SizedBox(
        //   height: 50,
        // ),
        // Row(
        //   children: [
        //     Container(
        //       height: 50,
        //       margin: EdgeInsets.all(20),
        //       child: IconButton(
        //         icon: Image.asset('assets/images/lightbulb.png'),
        //         onPressed: () async {
        //           //for finding refernce only  !?

        //           // Create a storage reference from our app
        //           final storageRef = FirebaseStorage.instance.ref();

        //           // Create a reference with an initial file path and name
        //           final pathReference = storageRef.child("/practices/ألف.mp3");
        //           // Create a reference to a file from a Google Cloud Storage URI
        //           final gsReference = FirebaseStorage.instance.refFromURL(
        //               "gs://tamakan-ef69b.appspot.com/practices/ألف.mp3");

        //           // print(await gsReference.getDownloadURL());
        //           // await player.play(
        //           //     DeviceFileSource(await gsReference.getDownloadURL()));

        //           await player.play(DeviceFileSource(recordURL));
        //         },
        //       ),
        //     ),
        //     Container(
        //       margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
        //       child: Text(
        //         'تلميح',
        //         style: TextStyle(fontSize: 30),
        //       ),
        //     )
        //   ],
        // ),
        // SingleChildScrollView(
        //   reverse: true,
        //   child: Text(text),
        // ),
        validatePronuciation(correctText),
        found
            ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    found = false;
                    text = '';
                    if (index == 5)
                      print('done game '); //get to map
                    //((index + 1) < lessonIDs.length)
                    else {
                      index++;
                    }
                  });
                },
                child: const Text('next'),
              )
            : Container(),
        //for testing only
        ElevatedButton(
          onPressed: () {
            print(index.toString() + " index");

            setState(() {
              found = false;
              text = '';
              if (index + 1 == 5) {
                print('done game ' + accumelatedPoints.toString());
                FirebaseFirestore.instance
                    .collection('parent')
                    .doc(signedInUser.email)
                    .collection('children')
                    .doc(widget.childID)
                    .update({'points': child.points + accumelatedPoints});
                Navigator.of(context).pop();
              } else {
                index++;
              }
            });
          },
          child: const Text('nexttt'),
        )
      ],
    );
  }

  Widget gameStatusBar() {
    int completed = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: lessonIDs
          .map(
            (e) => ((index == 5) || (completed++ < index))
                ? new Container(
                    color: Colors.green,
                    height: 8,
                    width: 80,
                    margin: EdgeInsets.all(10),
                  )
                : new Container(
                    color: Colors.grey,
                    height: 8,
                    width: 80,
                    margin: EdgeInsets.all(10),
                  ),
          )
          .toList(),
    );
  }

  Future<void> readChildData(String childID) async {
    await FirebaseFirestore.instance
        .collection('parent')
        .doc(signedInUser.email)
        .collection('children')
        .where('childID', isEqualTo: childID)
        .get()
        .then((value) {
      for (var element in value.docs) {
        child = Child.fromJson(element.data());
        // setState(() {
        //   readingData = false;
        // });
      }
    });
  }

  showHintVideo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer.network(
                      'https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/practices%20videos%2FUntitled%20video%20-%20Made%20with%20Clipchamp%20(36).mp4?alt=media&token=651c3877-a08d-41dc-b981-5371aa18ba18',
                      betterPlayerConfiguration: BetterPlayerConfiguration(
                        autoPlay: true,
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_speech/google_speech.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';

import '../Model/child.dart';

//working but correct text is repated a lot

class GameView extends StatefulWidget {
  const GameView({super.key, required this.practiceID, required this.childID});

  final String practiceID;
  final String childID;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final RecorderStream _recorder = RecorderStream();
  final player = AudioPlayer();

  late List<int> lessonIDs = List<int>.empty(growable: true);
  int index = 0;
  late String recordURL;
  late List<String> correctText = List<String>.empty(growable: true);
  late String lesson = '';
  bool waiting = true;
  late Child child;
  var accumelatedPoints = 0;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;

  var correct = false;
  var getCorrectTextOnce = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectRandomLessons(widget.practiceID);
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
          backgroundColor: const Color(0xffFF6B6B),
        ),
        body: waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: index < 5
                    ? practice(
                        lessonIDs[index].toString(),
                      )
                    : practice(lessonIDs.last.toString()),
              ),
      ),
    );
  }

  void getOnce(String id) {
    print(getCorrectTextOnce.toString() + ' getonce');
    if (!getCorrectTextOnce) {
      getLessonData(id);
      getCorrectText(id);
      getCorrectTextOnce = true;
    }
  }

  Widget practice(String id) {
    getOnce(id);
    //getLessonData(id);
    //getCorrectText(id);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          child: gameStatusBar(), //from index
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                backgroundColor: const Color(0xff4ECDC4), //4ECDC4
                child: Text(
                  lesson,
                  style:
                      const TextStyle(color: Color(0xffFFE66D), fontSize: 100),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: recognizing ? stopRecording : streamingRecognize,
          child: Card(
            color: recognizing ? const Color(0xffF7FFF7) : Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: double.infinity,
              height: 100,
              padding:
                  const EdgeInsets.symmetric(horizontal: 105, vertical: 20),
              child: Image.asset(
                'assets/images/mic.png',
                scale: 1.2,
              ),
            ),
          ),
        ),
        // InkWell(
        //   child: Card(
        //     elevation: 4,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 105, vertical: 20),
        //       child: Image.asset(
        //         'assets/images/listen.png',
        //         scale: 5,
        //       ),
        //     ),
        //   ),
        //   onTap: () async {
        //     await player.play(DeviceFileSource(recordURL));
        //   },
        // ),
        InkWell(
          onTap: null,
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              child: Image.asset(
                'assets/images/lightbulb.png',
                scale: 1.4,
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (recognizeFinished)
                _RecognizeContent(
                  text: text,
                ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            print(index.toString() + " index");

            setState(() {
              index++; //?
              getCorrectTextOnce = false;
              // text = '';
              // if (index + 1 == 5) {
              //   print('done game ' + accumelatedPoints.toString());
              //   FirebaseFirestore.instance
              //       .collection('parent')
              //       .doc(signedInUser.email)
              //       .collection('children')
              //       .doc(widget.childID)
              //       .update({'points': child.points + accumelatedPoints});
              //   Navigator.of(context).pop();
              // } else {
              //   index++;
              // }
            });
          },
          child: const Text('nexttt'),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     showCustomDialog(context);
        //     //Navigator.of(context).pop();
        //   },
        //   child: const Text('testing dialog'),
        // )
      ],
    );
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: false,
        sampleRateHertz: 16000,
        languageCode: 'ar-SA',
        speechContexts: [
          SpeechContext(correctText),
        ],
        useEnhanced: true,
      ); //en-US -- ar-SA

  void streamingRecognize() async {
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream!.add(event);
    });

    await _recorder.start();

    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        (await rootBundle.loadString('assets/test_service_account.json')));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream!);

    var responseText = '';

    responseStream.listen((data) {
      final currentText =
          data.results.map((e) => e.alternatives.first.transcript).join('\n');

      if (data.results.first.isFinal) {
        responseText += '\n' + currentText;
        setState(() {
          text = responseText;
          recognizeFinished = true;
        });
      } else {
        setState(() {
          text = responseText + '\n' + currentText;
          recognizeFinished = true;
        });
      }
    }, onDone: () {
      setState(() {
        recognizing = false;
      });
      validatePronuciation(correctText, text);
    });
  }

  void stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    setState(() {
      recognizing = false;
    });
  }

  void validatePronuciation(List correctText, String text) {
    text = text.trim();
    print('validate');
    print(correctText);
    print(text);

    if (correctText.contains(text)) {
      correct = true;
      print('correct');
      print('index before incrementing ' + index.toString());
      if (index < 4) {
        showGoodDialog(context);
        setState(() {
          index++;
          getCorrectTextOnce = false;
        });
        print('not complete ' + index.toString());
      } else {
        //make not closable
        print('complete');
        showCustomDialog(context);
      }

      //showCustomDialog(context);

      //after ending! with cusotn dialog
      // FirebaseFirestore.instance
      //     .collection('parent')
      //     .doc(signedInUser.email)
      //     .collection('children')
      //     .doc(widget.childID)
      //     .update({'points': child.points + 5});
      //print(child.points + 5);
      // setState(() {
      //   if (index + 1 != 5) {
      //     //correctText.clear();
      //     index++;
      //     getCorrectTextOnce = false;
      //   } else {
      //     print('done game ' + accumelatedPoints.toString());
      //     FirebaseFirestore.instance
      //         .collection('parent')
      //         .doc(signedInUser.email)
      //         .collection('children')
      //         .doc(widget.childID)
      //         .update({'points': child.points + accumelatedPoints});
      //     Navigator.pop(context);
      //   }
      // });
      // return const Text(
      //   'true',
      //   style: TextStyle(
      //     color: Colors.green,
      //     fontWeight: FontWeight.bold,
      //   ),
      // );
    } else {
      showBadDialog(context);
    }
    // else
    //   return Text(
    //     'false',
    //     style: TextStyle(
    //       color: Colors.red,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   );
  }

  Future getLessonData(String id) async {
    print('hereeee');
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
    print('here again');
    correctText.clear();
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('lesson')
        .doc(id)
        .collection('correctText')
        .get();
    for (var element in qs.docs) {
      correctText.add(element['text']);
    }
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

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xffFFFBEC),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Image.asset(
                              'assets/images/star1.png',
                              scale: 1.7,
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/star2.png',
                          scale: 1.5,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Image.asset(
                              'assets/images/star3.png',
                              scale: 1.7,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'أحسنت',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                'لقد اجتزت الدرس بنجاح',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                '5',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '! مجموع النقاط التي حصلت عليها',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/trophy.png',
                scale: 1.3,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff4ECDC4),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.home),
                        SizedBox(
                          width: 20,
                        ),
                        Text('الخريطة'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.play_arrow),
                        SizedBox(
                          width: 10,
                        ),
                        Text('الدرس التالي'),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
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

  void showGoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'أحسنت',
                  style: TextStyle(fontSize: 30),
                ),
                Icon(
                  Icons.thumb_up,
                  color: Colors.green,
                  size: 60,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showBadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'حاول مرة أخرى',
                  style: TextStyle(fontSize: 30),
                ),
                Icon(
                  Icons.thumb_down,
                  color: Colors.red,
                  size: 60,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecognizeContent extends StatelessWidget {
  final String? text;

  const _RecognizeContent({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Text(
            'The text recognized by the Google Speech Api:',
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            text ?? '---',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}

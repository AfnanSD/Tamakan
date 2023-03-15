import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_speech/google_speech.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:tamakan/View/levels.dart';

import '../Model/child.dart';

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
  bool readingChihldData = true;
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
    _recorder.initialize();
    selectRandomLessons(widget.practiceID);
    getCurrentUser();
    readChildData(widget.childID);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: waiting || readingChihldData
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/b2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      index < 5
                          ? practice2(
                              lessonIDs[index].toString(),
                            )
                          : practice2(lessonIDs.last.toString()),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget gameStatusBar2() {
    int completed = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...lessonIDs
            .map((e) => ((index == 5) || (completed++ < index))
                ? Container(
                    height: 10,
                    width: 50,
                    color: const Color.fromRGBO(255, 230, 109, 1),
                  )
                : Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey,
                  ))
            .toList(),
        Container(
          height: 10,
          width: 50,
          color: Colors.white,
        )
      ],
    );
  }

  Widget practice2(String id) {
    getOnce(id);
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //home icon
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Color(0xff1A535C),
                          ),
                        ),
                      ),
                    ),
                    //game bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: gameStatusBar2(),
                            ),
                          ),
                          Row(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                ),
                                color: Colors.white,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  height: 80,
                                  width: 80,
                                  child: Image.asset(
                                    'assets/images/trophy.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //points
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Card(
                        margin: const EdgeInsets.all(7),
                        shadowColor: Colors.grey,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 15,
                          ),
                          child: SizedBox(
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${child.points}'),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.star_rounded,
                                  size: 30,
                                  color: Color.fromRGBO(255, 230, 109, 1),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                lesson,
                style: const TextStyle(
                  fontSize: 300,
                  fontFamily: 'Blabeloo',
                  color: Color(0xff1A535C),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                //remove from reqs
                // Row(
                //   children: [
                //     const Spacer(),
                //     Card(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       margin: const EdgeInsets.symmetric(horizontal: 50),
                //       child: Column(
                //         children: [
                //           IconButton(
                //             onPressed: () {
                //               setState(() {
                //                 index++;
                //               });
                //             },
                //             icon: const Icon(
                //               Icons.lightbulb_outline_rounded,
                //               color: Color(
                //                   0xff1A535C), //Color(0xffFFE66D) - Color(0xff4ECDC4)
                //             ),
                //             iconSize: 70,
                //           ),
                //           const Text(
                //             'مساعدة',
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 15,
                //               color: Color(0xff1A535C),
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: IconButton(
                            onPressed: recognizing
                                ? stopRecording
                                : streamingRecognize,
                            icon: Icon(
                              Icons.mic_rounded,
                              color: recognizing
                                  ? const Color(0xffFF6B6B)
                                  : const Color(0xff1A535C),
                            ),
                            iconSize: 100,
                          ),
                        ),
                        const Text(
                          'سجل',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xff1A535C),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getOnce(String id) {
    if (!getCorrectTextOnce) {
      getLessonData(id);
      getCorrectText(id);
      getCorrectTextOnce = true;
    }
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
      );

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
      if (index < 4) {
        showGoodDialog(context);
        setState(() {
          index++;
          getCorrectTextOnce = false;
        });
      } else {
        //make not closable
        index++;
        showfinalDialog(context);
        //sound
        SoundEffects(
            "https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/sounds%2Fexcellentt.m4a?alt=media&token=aed3e890-d299-4f9b-b85d-847e2a12a74c");
        FirebaseFirestore.instance
            .collection('parent')
            .doc(signedInUser.email)
            .collection('children')
            .doc(widget.childID)
            .update({'points': child.points + 5});

        /////Ruba
        if (double.parse(widget.practiceID) == 7.5 && child.CurrentLevel <= 7) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 8});
        } else if (double.parse(widget.practiceID) == 14.5 &&
            child.CurrentLevel <= 14) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 15});
        } else if (double.parse(widget.practiceID) == 21.5 &&
            child.CurrentLevel <= 21) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 22});
        } else if (double.parse(widget.practiceID) == 28.5 &&
            child.CurrentLevel <= 28) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 29});
        } else if (double.parse(widget.practiceID) == 35.5 &&
            child.CurrentLevel <= 35) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 36});
        } else if (double.parse(widget.practiceID) == 42.5 &&
            child.CurrentLevel <= 42) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 43});
        } else if (double.parse(widget.practiceID) == 49.5 &&
            child.CurrentLevel <= 49) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 50});
        } else if (double.parse(widget.practiceID) == 56.5 &&
            child.CurrentLevel <= 56) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 57});
        } else if (double.parse(widget.practiceID) == 63.5 &&
            child.CurrentLevel <= 63) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 64});
        } else if (double.parse(widget.practiceID) == 70.5 &&
            child.CurrentLevel <= 70) {
          FirebaseFirestore.instance
              .collection('parent')
              .doc(signedInUser.email)
              .collection('children')
              .doc(widget.childID)
              .update({'CurrentLevel': 71});
        }

        ///
      }
    } else {
      showBadDialog(context);
      SoundEffects(
          "https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/sounds%2Fsad.m4a?alt=media&token=f139ff73-ecf0-44b8-b924-ce99ce1603ce");
    }
  }

  Future<void> SoundEffects(String sound) async {
    await player.play(DeviceFileSource(sound));
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
      children: [
        ...lessonIDs
            .map((e) => ((index == 5) || (completed++ < index))
                ? const Icon(
                    Icons.star,
                    color: Color.fromRGBO(255, 221, 64, 1),
                    size: 50,
                  )
                : const Icon(
                    Icons.star,
                    color: Colors.grey,
                    size: 50,
                  ))
            .toList(),
        Image.asset(
          'assets/images/trophy.png',
          scale: 1.3,
        ),
      ],
    );
  }

  void showfinalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color.fromARGB(255, 249, 248, 245),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/trophy-winner.json',
                  repeat: true, height: 250),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'أحسنت',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const Text(
                'لقد اجتزت التحدي بنجاح',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              // const Text(
              //   '5',
              //   style: TextStyle(
              //     fontSize: 30,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const Text(
                'لقد حصلت على 5 نقاط',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Lottie.asset('assets/animations/five-stars.json',
                  repeat: false, height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff4ECDC4),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.home),
                      SizedBox(
                        width: 20,
                      ),
                      Text('المراحل', style: TextStyle(fontSize: 17)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
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
        setState(() {
          readingChihldData = false;
        });
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
              children: [
                const Text(
                  'أحسنت',
                  style: TextStyle(fontSize: 30),
                ),
                Lottie.asset('assets/animations/happy-star.json',
                    repeat: false),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff4ECDC4)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'التالي',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
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
              children: [
                const Text(
                  'حاول مرة أخرى',
                  style: TextStyle(fontSize: 30),
                ),
                Lottie.asset('assets/animations/sad-star.json', repeat: false),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff4ECDC4)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'حسنا',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
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

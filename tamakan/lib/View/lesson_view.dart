//google cloud version
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_speech/google_speech.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:tamakan/View/levels/levels.dart';
import 'package:tamakan/View/widgets/child_points.dart';

import '../Model/child.dart';

class LessonView extends StatefulWidget {
  const LessonView({super.key, required this.lessonID, required this.childID});

  final String lessonID;
  final String childID;

  @override
  State<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  final RecorderStream _recorder = RecorderStream();
  final player = AudioPlayer();

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;

  List<String> correctText = List<String>.empty(growable: true);
  late String lesson = '';
  late String title = '';
  late String recordURL;
  var found = false;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  late Child child;

  String toValidate = '';

  var waiting = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recorder.initialize();
    getCorrectText(widget.lessonID);
    getLessonData(widget.lessonID);
    getCurrentUser();
    readChildData(widget.childID);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // appBar: AppBar(
        //   actions: <Widget>[
        //     Image.asset(
        //       'assets/images/droppedlogo.png',
        //       scale: 0.5,
        //     ),
        //   ],
        //   backgroundColor: const Color(0xffFF6B6B),
        // ),
        //singlechildscrollview
        body: waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : newUI(),

        // Column(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        //       child: Card(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         child: SizedBox(
        //           width: double.infinity,
        //           child: Center(
        //             child: Text(
        //               'الدرس $title',
        //               style: const TextStyle(
        //                 fontSize: 30,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     practice(widget.lessonID),
        //   ],
        // ),
      ),
    );
  }

  Widget newUI() {
    return Stack(
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
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    // Center(
                    //   child: Card(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(15.0),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 30.0, vertical: 10),
                    //       child: Text(
                    //         'الدرس $title',
                    //         style: const TextStyle(
                    //           fontFamily: 'Blabeloo',
                    //           fontSize: 30,
                    //           color: Color(0xff1A535C),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.home,
                              color: Color(0xff1A535C),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50.0, vertical: 10),
                            child: Text(
                              'الدرس $title',
                              style: const TextStyle(
                                fontFamily: 'Blabeloo',
                                fontSize: 30,
                                color: Color(0xff1A535C),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Card(
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
                                    color: Color.fromRGBO(255, 221, 64, 1),
                                  )
                                  // Image.asset(
                                  //   'assets/images/star3.png',
                                  //   scale: 5,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Center(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Text(
                    //       'الدرس $title',
                    //       style: const TextStyle(
                    //         fontFamily: 'Blabeloo',
                    //         fontSize: 30,
                    //         color: Color(0xff1A535C),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            practice2(widget.lessonID),
          ],
        ),
      ],
    );
  }

  Widget practice2(String id) {
    return Expanded(
      child: Column(
        children: [
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
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await player.play(DeviceFileSource(recordURL));
                      },
                      icon: const Icon(
                        Icons.volume_up_rounded,
                        color: Color(0xff1A535C),
                      ),
                      iconSize: 100,
                    ),
                    const Text(
                      'استمع',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed:
                          recognizing ? stopRecording : streamingRecognize,
                      icon: Icon(
                        Icons.mic_rounded,
                        color: recognizing
                            ? const Color(0xffFF6B6B)
                            : const Color(0xff1A535C),
                      ),
                      iconSize: 100,
                    ),
                    const Text(
                      'سجل',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => showHintVideo(context),
                      icon: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Color(
                            0xff1A535C), //Color(0xffFFE66D) - Color(0xff4ECDC4)
                      ),
                      iconSize: 100,
                    ),
                    const Text(
                      'مساعدة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget practice(String id) {
    return Column(
      children: [
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
        InkWell(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 105, vertical: 20),
              child: Image.asset(
                'assets/images/listen.png',
                scale: 5,
              ),
            ),
          ),
          onTap: () async {
            await player.play(DeviceFileSource(recordURL));
          },
        ),
        InkWell(
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
          onTap: () => showHintVideo(context),
        ),
        InkWell(
          onTap: recognizing ? stopRecording : streamingRecognize,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            color: recognizing
                ? const Color.fromARGB(255, 223, 255, 223)
                : Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 105, vertical: 20),
              child: Image.asset(
                'assets/images/mic.png',
                scale: 1.2,
              ),
            ),
          ),
        ),

        //for testing only
        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[
        //       if (recognizeFinished)
        //         _RecognizeContent(
        //           text: text,
        //         ),
        //     ],
        //   ),
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     showCustomDialog(context);
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
      print(text + " befor");
      print(correctText);
      toValidate = text;
      validatePronuciation(correctText, toValidate);
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
    print(widget.lessonID);
    print('validate');
    print(correctText);
    print(text);

    if (correctText.contains(text)) {
      showfinalDialog(context);
      FirebaseFirestore.instance
          .collection('parent')
          .doc(signedInUser.email)
          .collection('children')
          .doc(widget.childID)
          .update({'points': child.points + 3});

      ///Ruba
      ///
      if (int.parse(widget.lessonID) == child.CurrentLevel) {
        FirebaseFirestore.instance
            .collection('parent')
            .doc(signedInUser.email)
            .collection('children')
            .doc(widget.childID)
            .update({'CurrentLevel': child.CurrentLevel + 1});
      }
      print(child.CurrentLevel);
    } else {
      showBadDialog(context);
    }
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

  void showfinalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          // backgroundColor: const Color.fromARGB(255, 249, 248, 245),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/theree-stars.json', height: 450),
              const Text(
                'أحسنت',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const Text(
                'لقد اجتزت الدرس بنجاح',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Text(
                '3',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '! مجموع النقاط التي حصلت عليها',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                levels(childID: widget.childID),
                          ));
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.home),
                        SizedBox(
                          width: 20,
                        ),
                        Text('المراحل', style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff4ECDC4),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonView(
                              lessonID:
                                  (int.parse(widget.lessonID) + 1).toString(),
                              childID: widget.childID),
                        ),
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.chevron_left),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'الدرس التالي',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
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
      setState(() {
        waiting = false;
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

  Future getLessonData(String id) async {
    await FirebaseFirestore.instance
        .collection('lesson')
        .doc(id)
        .get()
        .then((value) {
      setState(() {
        recordURL = value['lessonRecord'];
        lesson = value['lesson'];
        title = value['title'];
      });
    });
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

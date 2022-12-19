import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:tamakan/View/learning_map.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key, required this.lessonID});

  final String lessonID;

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
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
    // TODO: implement initState
    super.initState();
    speech = stt.SpeechToText();
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
        body: practice(widget.lessonID),
      ),
    );
  }

  Widget practice(String id) {
    geturl(id);
    getCorrectText(id);
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        CircleAvatar(
          maxRadius: 100,
          backgroundColor: Color(0xff4ECDC4), //4ECDC4
          child: Text(
            lesson,
            style: TextStyle(color: Color(0xffFFE66D), fontSize: 100),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              margin: EdgeInsets.all(20),
              child: AvatarGlow(
                animate: isListening,
                glowColor: Theme.of(context).primaryColor,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                endRadius: 75.0,
                child: IconButton(
                  icon: Image.asset('assets/images/mic.png'),
                  onPressed: listen,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            Container(
              height: 50,
              margin: EdgeInsets.all(20),
              child: IconButton(
                icon: Image.asset('assets/images/lightbulb.png'),
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
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                'تلميح',
                style: TextStyle(fontSize: 30),
              ),
            )
          ],
        ),
        SingleChildScrollView(
          reverse: true,
          child: Text(text),
        ),
        validatePronuciation(correctText),
        found
            ? ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('back to learning'),
              )
            : Container(),
        //for testing only
        ElevatedButton(
          onPressed: () {
            showCustomDialog(context);
            //Navigator.of(context).pop();
          },
          child: const Text('testing back'),
        )
      ],
    );
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
                      primary: Color(0xffFFE66D),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LearningMap())),
                    child: Row(
                      children: [
                        Icon(Icons.home),
                        SizedBox(
                          width: 10,
                        ),
                        Text('الخريطة'),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: null,
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
}

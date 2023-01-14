import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

import 'package:tamakan/Model/child.dart';
import 'package:tamakan/View/learning_map.dart';

class Lesson extends StatefulWidget {
  const Lesson({super.key, required this.lessonID, required this.childID});

  final String lessonID;
  final String childID;

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
  late String title = '';
  bool found = false;
  late Child child;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speech = stt.SpeechToText();
    getCurrentUser();
    readChildData(widget.childID);
    updateData();
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
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    child: Center(
                        child: Text(
                      'الدرس $title',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    )),
                    width: double.infinity,
                  ),
                ),
              ),
              practice(widget.lessonID),
            ],
          ),
        ),
      ),
    );
  }

  Widget practice(String id) {
    getLessonData(id);
    getCorrectText(id);
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
        // Row(
        //   children: [
        //     Expanded(
        //       child: Card(
        //         color: isListening ? Color(0xffF7FFF7) : Colors.white,
        //         elevation: 4,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Container(
        //               height: 50,
        //               margin: EdgeInsets.all(20),
        //               child: IconButton(
        //                 icon: Image.asset('assets/images/mic.png'),
        //                 onPressed: listen,
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       child: Card(
        //         elevation: 4,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Container(
        //               height: 50,
        //               margin: EdgeInsets.all(20),
        //               child: IconButton(
        //                 icon: Image.asset('assets/images/listen.png'),
        //                 onPressed: () async {
        //                   // //for finding refernce only  !?

        //                   // // Create a storage reference from our app
        //                   // final storageRef = FirebaseStorage.instance.ref();

        //                   // // Create a reference with an initial file path and name
        //                   // final pathReference =
        //                   //     storageRef.child("/practices/ألف.mp3");
        //                   // // Create a reference to a file from a Google Cloud Storage URI
        //                   // final gsReference = FirebaseStorage.instance.refFromURL(
        //                   //     "gs://tamakan-ef69b.appspot.com/practices/ألف.mp3");

        //                   // // print(await gsReference.getDownloadURL());
        //                   // // await player.play(
        //                   // //     DeviceFileSource(await gsReference.getDownloadURL()));

        //                   await player.play(DeviceFileSource(recordURL));
        //                 },
        //               ),
        //             ),
        //             // Container(
        //             //   margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
        //             //   child: Text(
        //             //     'تلميح',
        //             //     style: TextStyle(fontSize: 30),
        //             //   ),
        //             // )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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
                      'assets/images/listen.png',
                      scale: 5,
                    ),
                  ),
                ),
                onTap: () async {
                  await player.play(DeviceFileSource(recordURL));
                },
              ),
            ],
          ),
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
        SingleChildScrollView(
          reverse: true,
          child: Text(text),
        ),
        //validatePronuciation(correctText),
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
          child: const Text('testing dialog'),
        )
      ],
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

  void updateData() async {
    // for (var i = 35; i < 71; i++) {
    //   await FirebaseFirestore.instance
    //       .collection('lesson')
    //       .doc(i.toString())
    //       .set({'lesson': '', 'lessonID': '', 'lessonRecord': '', 'title': ''});
    // }

    //testing
    // List<double> ids = List<double>.empty(growable: true);
    // await FirebaseFirestore.instance.collection('lesson').get().then((value) {
    //   for (var element in value.docs) {
    //     ids.add(double.parse(element['lessonID']));
    //   }
    // });
    // await FirebaseFirestore.instance.collection('practice').get().then((value) {
    //   for (var element in value.docs) {
    //     ids.add(double.parse(element['practiceID']));
    //   }
    // });
    // bool isInteger(num value) => (value % 1) == 0;

    // ids.sort();
    // print(isInteger(ids[0]).toString() + ids[0].toString());
    // print(isInteger(ids[7]).toString() + ids[7].toString());
    // print(ids);
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
      validatePronuciation(correctText);
      speech.stop();
    }
  }

  void validatePronuciation(List correctText) {
    for (var element in correctText) {
      if (text == element) found = true;
    }
    if (found) {
      showCustomDialog(context);
      FirebaseFirestore.instance
          .collection('parent')
          .doc(signedInUser.email)
          .collection('children')
          .doc(widget.childID)
          .update({
        'points': child.points + 5,
        // 'CurrentLevel': child.CurrentLevel + 1
      });
      print(child.points + 5);

      ///Ruba
      if (widget.lessonID == child.CurrentLevel) {
        FirebaseFirestore.instance
            .collection('parent')
            .doc(signedInUser.email)
            .collection('children')
            .doc(widget.childID)
            .update({'CurrentLevel': child.CurrentLevel! + 1});
      }
      print(child.CurrentLevel);

      ///
      ///
      // return const Text(
      //   'true',
      //   style: TextStyle(
      //     color: Colors.green,
      //     fontWeight: FontWeight.bold,
      //   ),
      // );
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
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Lesson(
                              lessonID:
                                  (int.parse(widget.lessonID) + 1).toString(),
                              childID: widget.childID),
                        ),
                      );
                    },
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
      print('done');
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

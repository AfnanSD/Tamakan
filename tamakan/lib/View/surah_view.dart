import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tamakan/View/navigationBarChild.dart';

class SurahView extends StatefulWidget {
  const SurahView({super.key, required this.surahName, required this.childID});

  final String surahName;
  final String childID;
  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  List<String> ayahs = List<String>.empty(growable: true);
  String surahImg = '';
  var gettingData = true;

  var selectedSurahRepetition = 1;
  var selectedAyahRepetition = 1;

  var playing = false;
  var paused = false;

  final player = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAyahs();
    getSurahData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/b2.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            gettingData
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      //header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 40),
                        child: Row(
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
                                  Icons.chevron_left,
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
                                    horizontal: 45.0, vertical: 10),
                                child: Text(
                                  'سورة ${widget.surahName}',
                                  style: const TextStyle(
                                    fontFamily: 'Blabeloo',
                                    fontSize: 30,
                                    color: Color(0xff1A535C),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => navigationChild(
                                              childID: widget.childID),
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.home,
                                    color: Color(0xff1A535C),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //surah
                      Expanded(
                        child: Center(
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Image.network(surahImg, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ),
                      //control
                      const Text('عدد تكرار السورة'),
                      amountWidgetForSurah(),
                      const Text('عدد تكرار الآية'),
                      amountWidgetForAyah(),
                      Card(
                        margin: const EdgeInsets.all(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (playing) {
                              print('paused!');
                              player.pause();
                              setState(() {
                                paused = true;
                                playing = false;
                              });
                            } else if (paused) {
                              print('resumed!');
                              player.resume();
                              setState(() {
                                paused = false;
                                playing = true;
                              });
                            } else if (!playing && !paused) {
                              print('start play');
                              repeateSurah(selectedSurahRepetition,
                                  selectedAyahRepetition, ayahs);
                              setState(() {
                                print('error?');
                                playing = true;
                              });
                            }
                          },
                          icon: Icon(
                            playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: const Color(0xff1A535C),
                          ),
                          iconSize: 100,
                        ),
                        //2 icons
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Column(
                        //       children: [
                        //         IconButton(
                        //           onPressed: playing
                        //               ? null
                        //               : () {
                        //                   repeateSurah(selectedSurahRepetition,
                        //                       selectedAyahRepetition, ayahs);
                        //                 },
                        //           icon: Icon(
                        //             Icons.play_arrow_rounded,
                        //             color: playing
                        //                 ? const Color(0xffFF6B6B)
                        //                 : paused
                        //                     ? Colors.grey
                        //                     : const Color(0xff1A535C),
                        //           ),
                        //           iconSize: 100,
                        //         ),
                        //         const Text(
                        //           'ابدأ',
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 20,
                        //             color: Color(0xff1A535C),
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //     const SizedBox(
                        //       width: 50,
                        //     ),
                        //     //pause
                        //     Column(
                        //       children: [
                        //         IconButton(
                        //           onPressed: () {
                        //             if (!paused) {
                        //               print('paused!');
                        //               player.pause();
                        //               setState(() {
                        //                 paused = true;
                        //                 playing = false;
                        //               });
                        //             } else {
                        //               print('resume!');
                        //               player.resume();
                        //               setState(() {
                        //                 paused = false;
                        //                 playing = true;
                        //               });
                        //             }
                        //           },
                        //           icon: Icon(
                        //             Icons.pause_rounded,
                        //             color: playing
                        //                 ? const Color(0xff1A535C)
                        //                 : Colors.grey,
                        //           ),
                        //           iconSize: 100,
                        //         ),
                        //         const Text(
                        //           'توقف',
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 20,
                        //             color: Color(0xff1A535C),
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void repeateSurah(int repeatSurah, int repeatAyah, List<String> URLs) {
    int x = 0;

    int tmpAyah = 0;
    int compeletedSurah = repeatAyah * URLs.length;

    int index = 0;

    player.play(DeviceFileSource(URLs[0]));
    player.onPlayerComplete.listen((event) async {
      setState(() {
        x++;
        tmpAyah++;
        compeletedSurah--;
      });

      if (x < (repeatAyah * repeatSurah * URLs.length)) {
        if (tmpAyah == repeatAyah) {
          index++;
          tmpAyah = 0;
        }
        if (compeletedSurah == 0) {
          compeletedSurah = repeatAyah * (URLs.length + 1);
          index = 0;
        }
        player.play(DeviceFileSource(URLs[index]));
      } else if (x == (repeatAyah * repeatSurah * URLs.length)) {
        setState(() {
          playing = false;
          paused = false;
        });
      }
    });
    player.stop(); //?
  }

  Future getAyahs() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('surah')
        .doc(widget.surahName)
        .collection('ayahs')
        .get();
    for (var element in qs.docs) {
      ayahs.add(element['recordURL']);
    }
  }

  Future getSurahData() async {
    await FirebaseFirestore.instance
        .collection('surah')
        .doc(widget.surahName)
        .get()
        .then((value) {
      setState(() {
        surahImg = value['imageURL'];
        gettingData = false;
      });
    });
  }

  Widget amountWidgetForSurah() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            width: 140,
            height: 40,
            child: Center(
              child: Text(selectedSurahRepetition.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                  )),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: (selectedSurahRepetition < 5 && !playing)
                  ? const Color(0xffFF6B6B)
                  : Colors.grey,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (selectedSurahRepetition < 5 && !playing) {
                      selectedSurahRepetition++;
                    }
                    if (paused) {
                      player.stop();
                      playing = false;
                      paused = false;
                    }
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            CircleAvatar(
              backgroundColor: (1 < selectedSurahRepetition && !playing)
                  ? const Color(0xffFF6B6B)
                  : Colors.grey,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (1 < selectedSurahRepetition && !playing) {
                      selectedSurahRepetition--;
                    }
                    if (paused) {
                      player.stop();
                      playing = false;
                      paused = false;
                    }
                  });
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget amountWidgetForAyah() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            width: 140,
            height: 40,
            child: Center(
              child: Text(selectedAyahRepetition.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                  )),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: (selectedAyahRepetition < 5 && !playing)
                  ? const Color(0xffFF6B6B)
                  : Colors.grey,
              child: IconButton(
                onPressed: () {
                  //if paused restart? set state
                  setState(() {
                    if (selectedAyahRepetition < 5 && !playing) {
                      selectedAyahRepetition++;
                    }
                    if (paused) {
                      player.stop();
                      playing = false;
                      paused = false;
                    }
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            CircleAvatar(
              backgroundColor: (1 < selectedAyahRepetition && !playing)
                  ? const Color(0xffFF6B6B)
                  : Colors.grey,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (1 < selectedAyahRepetition && !playing) {
                      selectedAyahRepetition--;
                    }
                    if (paused) {
                      player.stop();
                      playing = false;
                      paused = false;
                    }
                  });
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

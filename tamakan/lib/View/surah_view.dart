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
  List<String> ayahsRecords = List<String>.empty(growable: true);
  List<String> ayahsTexts = List<String>.empty(growable: true);
  int ayahNum = -1;
  String surahImg = '';
  var gettingData = true;

  var selectedSurahRepetition = 1;
  var selectedAyahRepetition = 1;

  var playing = false;
  var paused = false;

  final player = AudioPlayer();

  int index = 0;
  var stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAyahs();
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 25),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ayahsTexts[0],
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontFamily: 'UthmanicHafs',
                                        color: (index == 0 && playing)
                                            ? const Color(0xff4ECDC4)
                                            : Colors.black,
                                      ),
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      children: ayahsTexts.map((e) {
                                        int i = ayahsTexts.indexOf(e);
                                        if (i == 0) {
                                          return const Text('');
                                        }
                                        return Text(
                                          e,
                                          style: TextStyle(
                                            fontSize: 35,
                                            fontFamily: 'UthmanicHafs',
                                            color: (index == i && playing)
                                                ? const Color(0xff4ECDC4)
                                                : Colors.black,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //control
                      const Text(
                        'تكرار السورة',
                        style: TextStyle(fontSize: 20),
                      ),
                      amountWidgetForSurah(),
                      const Text(
                        'تكرار الآية',
                        style: TextStyle(fontSize: 20),
                      ),
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
                                print('num' + 2.toString());
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
                                  selectedAyahRepetition, ayahsRecords);
                              setState(() {
                                //print('error?');
                                playing = true;
                                paused = false;
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

    index = 0;

    setState(() {
      ayahNum = 0;
    });

    player.play(DeviceFileSource(URLs[0]));

    stream = player.onPlayerComplete.listen(
      (event) async {
        setState(() {
          x++;
          tmpAyah++;
          compeletedSurah--;
        });
        print('x is: ' + x.toString());
        if (x < (repeatAyah * repeatSurah * URLs.length)) {
          if (tmpAyah == repeatAyah) {
            index++;
            setState(() {
              ayahNum++;
            });
            tmpAyah = 0;
          }
          if (compeletedSurah == 0) {
            compeletedSurah = repeatAyah * URLs.length;
            index = 0;
            ayahNum = -1;
          }
          player.play(DeviceFileSource(URLs[index]));
        } else if (x == (repeatAyah * repeatSurah * URLs.length)) {
          setState(() {
            print('num' + 3.toString());
            playing = false;
            paused = false;
          });
          stream.pause();
        }
      },
    );
    player.stop(); //?
  }

  Future getAyahs() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('surah')
        .doc(widget.surahName)
        .collection('ayahs')
        .get();
    for (var element in qs.docs) {
      ayahsRecords.add(element['recordURL']);
      ayahsTexts.add(element['text']);
    }
    setState(() {
      ayahsTexts;
      gettingData = false;
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
              backgroundColor: (selectedSurahRepetition < 10 && !playing)
                  ? const Color(0xff1A535C)
                  : Colors.grey,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (selectedSurahRepetition < 10 && !playing) {
                      selectedSurahRepetition++;
                    }
                    if (paused) {
                      player.stop();
                      stream.pause();
                      print('num' + 4.toString());
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
                  ? const Color(0xff1A535C)
                  : Colors.grey,
              child: IconButton(
                onPressed: () {
                  if (1 < selectedSurahRepetition && !playing) {
                    setState(() {
                      selectedSurahRepetition--;
                    });
                  }
                  if (paused) {
                    player.stop();
                    stream.pause();
                    setState(() {
                      print('num' + 5.toString());
                      playing = false;
                      paused = false;
                    });
                  }
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
              backgroundColor: (selectedAyahRepetition < 10 && !playing)
                  ? const Color(0xff1A535C)
                  : Colors.grey,
              child: IconButton(
                onPressed: () {
                  if (selectedAyahRepetition < 10 && !playing) {
                    setState(() {
                      selectedAyahRepetition++;
                    });
                  }
                  if (paused) {
                    print('increas!');
                    player.stop();
                    stream.pause();
                    setState(() {
                      print('num' + 6.toString());
                      playing = false;
                      paused = false;
                    });
                  }
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
                  ? const Color(0xff1A535C)
                  : Colors.grey,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (1 < selectedAyahRepetition && !playing) {
                      selectedAyahRepetition--;
                    }
                    if (paused) {
                      player.stop();
                      stream.pause();
                      print('num' + 7.toString());
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

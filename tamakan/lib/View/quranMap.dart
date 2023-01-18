import 'package:flutter/material.dart';
import 'package:tamakan/View/displayverse.dart';

import 'package:responsive_sizer/responsive_sizer.dart';


class Quran_map extends StatelessWidget {
  const Quran_map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return  ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Map(),
        );
      },
    );

  }
}

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  List<int> surah_number=[95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114];

List<String> surahs=['سُوْرَۃُ التِّين','سُوْرَۃُ العَلَق','سُوْرَۃُ القَدْر','سُوْرَۃُ البَيِّنَة','سُوْرَۃُ الزَّلْزَلَة','سُوْرَۃُ العَادِيَات','سُوْرَۃُ القَارِعَة','سُوْرَۃُ التَّكَاثُر','سُوْرَۃُ العَصْر','سُوْرَۃُ الهُمَزَة','سُوْرَۃُ الفِيل','سُوْرَۃ قُرَيْش','سُوْرَۃُ المَاعُون','سُوْرَۃُ الكَوْثَر','سُوْرَۃُ الكَافِرُون','سُوْرَۃُ النَّصْر','سُوْرَۃُ المَسَد','سُوْرَۃُ الإِخْلَاص','	سُوْرَۃُ الفَلَق','سُوْرَۃُ النَّاس'];
List<double> left=[250,150,250,150,250,150,250,150,250,150,250,150,250,150,250,150,250,150,250,150];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Colors.transparent,
      body:SingleChildScrollView(
        reverse: true,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                image:DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover,
                 // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                ),
              ),
              child:Stack(
                children: [
                  Positioned(
                    top: 570,
                    left: 200,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[10],surah_name: surahs[10],)));
                        },
                        child: Text(surahs[10],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 500,
                    left: 60,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[11],surah_name: surahs[11],)));
                        },
                        child: Text(surahs[11],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w800
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 420,
                    left: 120,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[12],surah_name:surahs[12],)));

                        },
                        child: Text(surahs[12],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 360,
                    left: 240,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[13],surah_name: surahs[13],)));

                        },
                        child: Text(surahs[13],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 300,
                    left: 150,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[14],surah_name: surahs[14],)));

                        },
                        child: Text(surahs[14],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 270,
                    left: 60,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[15],surah_name: surahs[15],)));

                        },
                        child: Text(surahs[15],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 180,
                    left: 100,
                    child: SizedBox(
                      height: 60,
                      width: 70,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[16],surah_name: surahs[16],)));
                        },
                        child: Text(surahs[16],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140,
                    left: 180,
                    child: SizedBox(
                      height: 60,
                      width: 90,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[17],surah_name:surahs[17],)));

                        },
                        child: Text(surahs[17],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    left: 250,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[18],surah_name: surahs[18],)));

                        },
                        child: Text(surahs[18],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 140,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[19],surah_name: surahs[19],)));
                        },
                        child: Text(surahs[19],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                image:DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover,
                  // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                ),
              ),
              child:Stack(
                children: [
                  Positioned(
                    top: 550,
                    left: 260,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[0],surah_name: surahs[0],)));
                        },
                        child: Text(surahs[0],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w800
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 500,
                    left: 60,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[1],surah_name: surahs[1],)));
                        },
                        child: Text(surahs[1],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w800
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 400,
                    left: 120,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[2],surah_name:surahs[2],)));

                        },
                        child: Text(surahs[2],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 350,
                    left: 230,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[3],surah_name: surahs[3],)));

                        },
                        child: Text(surahs[3],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 300,
                    left: 160,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[4],surah_name: surahs[4],)));

                        },
                        child: Text(surahs[4],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 280,
                    left: 60,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[5],surah_name: surahs[5],)));

                        },
                        child: Text(surahs[5],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    left: 30,
                    child: SizedBox(
                      height: 60,
                      width: 70,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[6],surah_name: surahs[6],)));
                        },
                        child: Text(surahs[6],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 170,
                    left: 120,
                    child: SizedBox(
                      height: 60,
                      width: 90,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[7],surah_name:surahs[7],)));

                        },
                        child: Text(surahs[7],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 230,
                    child: SizedBox(
                      height: 60,
                      width: 70,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[8],surah_name: surahs[8],)));

                        },
                        child: Text(surahs[8],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 170,
                    child: SizedBox(
                      height: 60,
                      width: 80,
                      child:   ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Display(number:surah_number[9],surah_name: surahs[9],)));
                        },
                        child: Text(surahs[9],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            )),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
        ),
      );
  }
}

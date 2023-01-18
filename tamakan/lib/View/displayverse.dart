import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
class Display extends StatefulWidget {
final int number;
final String surah_name;
Display({required this.number,required this.surah_name});
  @override
  State<Display> createState() => _DisplayState();
}
class _DisplayState extends State<Display> {
  bool is_play=false;
  final player = AudioPlayer();
  List<String> items = [
    '1','2','3','4','5','6','7','8','9','10'
  ];
  String dropdownvalue="عدد التكرار";
int  numberOftimesToPlay=0;

bool stop=false;
Future<void> Repetition()async{
  final duration = await player.setUrl(quran.getAudioURLBySurah(widget.number).toString());
  player.play();
    player.setLoopMode(LoopMode.all);
    setState(() {
      is_play=true;
    });
}
  Future<bool> Selected_repetition()async{
  setState(() {
    is_play=true;
  });
    final duration =  player.setUrl(quran.getAudioURLBySurah(widget.number).toString());
  await player.play();
  await player.pause();
  setState(() {
    is_play=false;
  });
  return true;
}
  @override
  void dispose() {
  player.dispose();
    super.dispose();
  }
  @override
  void initState(){
    final duration =  player.setUrl(quran.getAudioURLBySurah(widget.number).toString());
  }
  DateTime currentBackPressTime=DateTime.now();
  Future<bool> onwillpop()async{
    if(is_play==true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("وقف الصوت للعودة"),
      ));
      return false;
    }
    else
      return true;
  }
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(child:
      Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Colors.white,
      body:
      SingleChildScrollView(
      child:
      Column(
        children: [
          Container(
            height: 14.h,
        width: 100.w,
        padding: EdgeInsets.only(left: 150,top: 20),
        child: Text(widget.surah_name,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: Colors.blue
        ),
        ),
      ),
         Padding(padding: EdgeInsets.only(left: 10,right: 10),
         child:  Container(
           height:45.h,
           width: 100.w,
           decoration: BoxDecoration(
               border: Border.all(color: Colors.black)
           ),
           child: Column(
             children: [
               Text(quran.basmala,
               style: TextStyle(
                 fontSize: 15,
                 fontWeight: FontWeight.w800,
               ),
               ),
               SizedBox(height: 20,),
                Container(
                  height: 230,
                  child:  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:quran.getVerseCount(widget.number),
                      itemBuilder: (context,index){
                        return  ListTile(
                            title:Text(
                          quran.getVerse(widget.number, index + 1, verseEndSymbol: true),
                          textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500
                              ),
                        ),
                        );
                      }
                  ),
                )
             ],
           ),
         ),
         ),
      Container(
        height: 100,
        width: 100,
        child: ElevatedButton(
            onPressed: ()async{
                  if(is_play==false) {
                    setState(() {
                      is_play=true;
                    });
                    // final duration = await player.setUrl(quran.getAudioURLBySurah(widget.number).toString());
                    await player.play();
                    await player.pause();
                    setState(() {
                      is_play=false;
                    });
                  }
                  else if(is_play==true) {
                    setState(() {
                      is_play=false;
                    });
                    await player.pause();
                  }
            }, child: CircleAvatar(
          radius: 90,
          child: Icon(player.playing? Icons.pause_circle:Icons.play_circle,
          size: 50,),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
          shadowColor: MaterialStateProperty.resolveWith((states) => Colors.white),
          elevation: MaterialStateProperty.resolveWith((states) => 0),
        ),
        ),
      ),
          SizedBox(
            height: 20,
          ),
         Container(
           height: 40,
           width: 180,
           decoration: BoxDecoration(
             color: Colors.grey,
             borderRadius: BorderRadius.circular(7)
           ),

           child:  DropdownButton(
             elevation: 0,
               underline:SizedBox() ,
               hint: Row(
                 children: [
                   Icon(Icons.arrow_drop_down_circle,
                     color: Colors.white,
                   ),
                   SizedBox(width: 50,),
                   Text(dropdownvalue,
                     style: TextStyle(
                         color: Colors.white
                     ),
                   ),
                 ],
               ),
               icon: Icon(Icons.font_download,
               color: Colors.transparent,
               ),
               items: items.map((String items) {
                 return DropdownMenuItem(
                   value: items,
                   child: Text(items),
                 );
               }).toList(),
               // After selecting the desired option,it will
               // change button value to selected value
               onChanged: (String? newValue) async{
                 setState(() {
                   dropdownvalue = newValue!;
                 });
                 while(numberOftimesToPlay<=int.parse(dropdownvalue)){
                   print("Playing..");
                 var data= await Selected_repetition();
                  print("Done");
                   numberOftimesToPlay++;
                 }
             }
           ),
         ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            width: 180,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(7)
            ),
            child:  ElevatedButton(
              onPressed: (){
                Repetition();
              },
              child: Text("تكرار"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
      ),
    ),
          onWillPop: ()async=>onwillpop(),
      );

  }
}

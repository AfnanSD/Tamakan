import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tamakan/View/myChildren.dart';
import 'package:tamakan/View/parentProfileView.dart';

import 'manage_family.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Image.asset(
              'assets/images/droppedlogo.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
        ),
        body: Column(
          children: [
            SizedBox(
              width: 25,
              height: 25,
            ),
            Text("ماذا تود أن تفعل اليوم؟",
                style: Theme.of(context).textTheme.headline6),
            SizedBox(
              width: 10,
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const myChildren())), // need update
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  color: const Color.fromARGB(255, 244, 242, 201),
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.all(20.0),
                  child: Container(
                    height: 150,
                    width: 600,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset('assets/images/rabbit.png'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('واجهة الأطفال',
                            style: TextStyle(
                                fontSize: 35,
                                color: Color.fromARGB(255, 26, 83, 92))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const parentprofileview())), // need update
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  color: const Color.fromARGB(80, 78, 205, 196),
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.all(20.0),
                  child: Container(
                    height: 150,
                    width: 600,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset('assets/images/rabbit.png'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('الملف الشخصي',
                            style: TextStyle(
                                fontSize: 35,
                                color: Color.fromARGB(255, 26, 83, 92))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ManageFamily())), // need update
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  color: const Color.fromARGB(160, 255, 107, 107),
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.all(20.0),
                  child: Container(
                    height: 150,
                    width: 600,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset('assets/images/rabbit.png'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('إدارة العائلة',
                            style: TextStyle(
                                fontSize: 35,
                                color: Color.fromARGB(255, 26, 83, 92))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Center(
            //   child: InkWell(
            //     onTap: () => print('quran'), // need update
            //     child: Card(
            //       elevation: 20,
            //       shape: RoundedRectangleBorder(
            //         side: BorderSide(
            //           color: Theme.of(context).colorScheme.outline,
            //         ),
            //         borderRadius: const BorderRadius.all(Radius.circular(40)),
            //       ),
            //       color: Color.fromARGB(255, 227, 224, 182),
            //       clipBehavior: Clip.hardEdge,
            //       margin: EdgeInsets.all(20.0),
            //       child: Container(
            //         height: 150,
            //         width: 600,
            //         padding: const EdgeInsets.all(8.0),
            //         child: Row(
            //           children: [
            //             Image.asset('assets/images/rabbit.jpg'),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text('يمكنك استبدال نقاط أطفالك من هنا!',
            //                 style: TextStyle(
            //                     fontSize: 25,
            //                     color: Color.fromARGB(255, 26, 83, 92))),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

//         body: SafeArea(
//           child: Center(
//             child: Container(
//               margin: const EdgeInsets.all(50.0),
//               child: ListView(
//                 children: <Widget>[
//                   Card(
//                     elevation: 20,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                         color: Theme.of(context).colorScheme.outline,
//                       ),
//                       borderRadius: const BorderRadius.all(Radius.circular(12)),
//                     ),
//                     color: const Color.fromARGB(255, 244, 242, 201),
//                     clipBehavior: Clip.hardEdge,
//                     margin: EdgeInsets.all(20.0),
//                     child: Padding(
//                       padding: const EdgeInsets.all(55.0),
//                       child: Container(
//                          child: Image.asset('assets/images/clud.png'),
                        
//                         child: const Text(
//                           'يمكنك الانتقال الى الواجهة المخصصة للأطفال من هنا!',
//                           style: TextStyle(fontSize: 25, color: Colors.red),
//                         ),
                        
//                       ),
//                     ),
//                   ),
//                   Card(
//                     elevation: 20,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                         color: Theme.of(context).colorScheme.outline,
//                       ),
//                       borderRadius: const BorderRadius.all(Radius.circular(12)),
//                     ),
//                     margin:
//                         EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
//                     color: Color.fromARGB(255, 244, 242, 201),
//                     clipBehavior: Clip.hardEdge,
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(40.0),
//                       onTap: () {
//                         debugPrint('Card tapped1.');
//                       },
//                       leading: FlutterLogo(),
//                       title: Text('One-line with leading widget1'),
//                     ),
//                   ),
//                   Card(
//                     elevation: 20,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                         color: Theme.of(context).colorScheme.outline,
//                       ),
//                       borderRadius: const BorderRadius.all(Radius.circular(12)),
//                     ),
//                     margin:
//                         EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
//                     color: Color.fromARGB(255, 244, 242, 201),
//                     clipBehavior: Clip.hardEdge,
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(40.0),
//                       onTap: () {
//                         debugPrint('Card tapped1.');
//                       },
//                       leading: FlutterLogo(),
//                       title: Text('One-line with leading widget1'),
//                     ),
//                   ),
//                   Card(
//                     elevation: 20,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                         color: Theme.of(context).colorScheme.outline,
//                       ),
//                       borderRadius: const BorderRadius.all(Radius.circular(12)),
//                     ),
//                     margin:
//                         EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
//                     color: Color.fromARGB(255, 244, 242, 201),
//                     clipBehavior: Clip.hardEdge,
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(40.0),
//                       onTap: () {
//                         debugPrint('Card tapped1.');
//                       },
//                       leading: FlutterLogo(),
//                       title:
//                           Center(child: Text('One-line with leading widget1')),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:tamakan/Model/coupon.dart';
import 'package:tamakan/View/widgets/child_points.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

import '../Model/child.dart';
import '../Model/couponType.dart';
import '../Model/userModel.dart';
import 'manage_family.dart';

class ExhcangePoints extends StatefulWidget {
  const ExhcangePoints({super.key, required this.childID});

  final String childID;

  @override
  State<ExhcangePoints> createState() => _ExhcangePointsState();
}

//check dates? start and end
//check available?

class _ExhcangePointsState extends State<ExhcangePoints> {
  var readingChildData = true;
  late Child child;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  late Coupon coupon;

  late List<CouponType> coupons = List<CouponType>.empty(growable: true);
  var readingCouponsData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    readChildData(widget.childID);
    getCoupons();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Image.asset(
              'assets/images/logo3.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
        ),
        body: readingChildData || readingCouponsData
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'قائمة القسائم',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                        ChildPoints(child: child),
                      ],
                    ),
                    coupons.isEmpty
                        ? Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50.0),
                                child: SizedBox(
                                  height: 400,
                                  child: LottieBuilder.asset(
                                    'assets/animations/not-found.json',
                                    repeat: false,
                                    fit: BoxFit.cover,
                                    //height: 200,
                                  ),
                                ),
                              ),
                              Text(
                                'عذرا, لا توجد قسائم حاليا',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.grey[700]),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: ListView.builder(
                              itemCount: coupons.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ListTile(
                                      title: Text(coupons[index].name),
                                      subtitle: Text(
                                          'استبدل ${coupons[index].points} نقطة \n${coupons[index].description}'),
                                      leading: Image.network(
                                          coupons[index].pictureURL),
                                      trailing: TextButton(
                                          onPressed: () {
                                            if (child.points >=
                                                coupons[index].points) {
                                              showConfirmationDialog(
                                                coupons[index].name,
                                                coupons[index].amount,
                                                coupons[index].points,
                                              );
                                            } else {
                                              showNotEnoughPointsDialof(
                                                  coupons[index].points);
                                            }
                                          },
                                          child: Text('استبدال')),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
      ),
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
        .where('childID', isEqualTo: childID) //why not doc(child.childID)?
        .get()
        .then((value) {
      for (var element in value.docs) {
        child = Child.fromJson(element.data());
        setState(() {
          readingChildData = false;
        });
      }
    });
  }

  Future<void> getCoupons() async {
    await FirebaseFirestore.instance
        .collection('couponType')
        .get()
        .then((value) {
      for (var element in value.docs) {
        CouponType c = CouponType.fromJson(element.data());
        //check for amount
        if (c.startDate.isBefore(DateTime.now()) &&
            c.endDate.isAfter(DateTime.now()) &&
            c.amount > 0) coupons.add(c);
      }
      setState(() {
        readingCouponsData = false;
      });
    });
  }

  Future<void> exchangeCoupon(String couponName, int amount, int points) async {
    print(amount.toString() + couponName);
    FirebaseFirestore.instance
        .collection('coupon')
        .doc(amount.toString() + couponName)
        .update({'childID': child.childID});
    FirebaseFirestore.instance
        .collection('couponType')
        .doc(couponName)
        .update({'amount': (--amount)});
    FirebaseFirestore.instance
        .collection('parent')
        .doc(signedInUser.email)
        .collection('children')
        .doc(child.childID)
        .update({'points': child.points - points});

    final serviceId = 'service_w5ei0k1';
    final templateId = 'template_mxy1yae';
    final userId = '5tJEsLojudk2YIKcD';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'parent_email': signedInUser.email,
          'point': points,
          'coupon_name': couponName,
          'coupon_ID': coupon.couponID,
          'child_name': child.name,
        },
      }),
    );

//old
    // FirebaseFirestore.instance
    //     .collection('coupon')
    //     .where('name', isEqualTo: couponName)
    //     .get()
    //     .then(
    //   (value) async {
    //     print(value.docs.length);
    //     var found = false;
    //     for (var element in value.docs) {
    //       coupon = Coupon.fromJson(element.data()); //here is the copounID
    //       if (coupon.childID.isEmpty) {
    //         FirebaseFirestore.instance
    //             .collection('coupon')
    //             .doc(coupon.couponID)
    //             .update({'childID': child.childID});
    //         found = true;
    //       }
    //       if (found) break;
    //       final serviceId = 'service_w5ei0k1';
    //       final templateId = 'template_mxy1yae';
    //       final userId = '5tJEsLojudk2YIKcD';

    //       final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    //       final response = await http.post(
    //         url,
    //         headers: {
    //           'origin': 'http://localhost',
    //           'Content-Type': 'application/json',
    //         },
    //         body: json.encode({
    //           'service_id': serviceId,
    //           'template_id': templateId,
    //           'user_id': userId,
    //           'template_params': {
    //             'parent_email': signedInUser.email,
    //             'point': points,
    //             'coupon_name': couponName,
    //             'coupon_ID': coupon.couponID,
    //             'child_name': child.name,
    //           },
    //         }),
    //       );
    //     }
    //   },
    // );
  }

/*
  Future SendEmail(String couponName, int points) async {
    print("SendEmail******************************");
    // UserModel? userModel;
    // await FirebaseFirestore.instance
    //     .collection('parent')
    //     .doc(FirebaseAuth.instance.currentUser!.email)
    //     .get()
    //     .then((value) {
    //   userModel = UserModel.fromSnap(value);
    // });
    // Coupon? coupon;
    // await FirebaseFirestore.instance
    //     .collection('coupon')
    //     .where('name', isEqualTo: couponName)
    //     .get()
    //     .then(
    //   (value) {
    //     for (var element in value.docs) {
    //       coupon = Coupon.fromJson(element.data());
    //     }
    //   },
    // );
    // CouponType? couponType;
    // await FirebaseFirestore.instance
    //     .collection('coupon')
    //     .where('name', isEqualTo: couponName)
    //     .get()
    //     .then(
    //   (value) {
    //     for (var element in value.docs) {
    //       couponType = CouponType.fromJson(element.data());
    //     }
    //   },
    // );

    print("Information******************************");
    print(signedInUser.email);
    // print(userModel!.name);
    print(child.name);
    print(points);
    print(couponName);
    print(coupon.couponID);
    // print(couponType!.startDate);
    // print(coupon!.endDate);
    // print(couponType!.descripton);
    // print(coupon!.couponID);
//  'parent_name': userModel!.name,
//           'childName': child.name,
//           'point': points,
//           'coupon_name': couponName,
//           'startDate': couponType!.startDate,
//           'endDate': coupon!.endDate,
//           'description': couponType!.descripton,
//           'couponID': coupon!.couponID,

    final serviceId = 'service_w5ei0k1';
    final templateId = 'template_mxy1yae';
    final userId = '5tJEsLojudk2YIKcD';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'parent_email': signedInUser.email,
          'point': points,
          'coupon_name': couponName,
          'coupon_ID': coupon.couponID,
        },
      }),
    );
  }
*/
  void showConfirmationDialog(String name, int amount, int couponPoints) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    child: Text(
                      'هل أنت متأكد من استبدال ${couponPoints} نقطة بقسيمة ${name} ؟',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xffFF6B6B)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Center(child: Text('الغاء')),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xff4ECDC4)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              exchangeCoupon(name, amount, couponPoints);
                              // SendEmail(name, couponPoints);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const ManageFamily(),
                              //   ),
                              // );
                            },
                            child: const Center(child: Text('تأكيد')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void showNotEnoughPointsDialof(int points) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    child: Text(
                      'عدد نقاط طفلك أقل من ${points}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xffFF6B6B)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Center(child: Text('حسنا')),
                        width: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}

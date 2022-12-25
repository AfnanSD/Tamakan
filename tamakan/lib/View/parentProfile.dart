import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamakan/Controller/authController.dart';
import 'package:tamakan/Model/userModel.dart';
import 'package:tamakan/View/deleteAccountView.dart';
import 'package:tamakan/View/parentHome.dart';
import 'package:tamakan/View/widgets/TextInputField.dart';
import 'package:tamakan/View/widgets/labels.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';

class parentprofileview extends StatefulWidget {
  const parentprofileview({super.key});

  @override
  State<parentprofileview> createState() => _parentprofileviewState();
}

final List<String> genders = [
  'أنثى',
  'ذكر',
];
String? gender = 'أنثى';
final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
late String? imageURL;
final picker = ImagePicker();
late File? _image = null;

class _parentprofileviewState extends State<parentprofileview> {
  UserModel? userModel;

  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lodProfile();
  }

  @override
  Widget build(BuildContext context) {
    //updata button
    final updataButton = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromRGBO(255, 230, 109, 1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        onPressed: () async {
          AuthController().editProfile(userModel!.name, userModel!.email,
              userModel!.password, userModel!.gender, userModel!.birthdate);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => parentprofileview()));
        },
        child: Text(
          "تعديل",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    //cancel button
    final cancelButton = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 76, 180, 184),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => parentHome()));
        },
        child: Text(
          "العودة",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
//delete button
    final deleteButton = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffFF6B6B),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const deleteAccount()))
        },
        child: Text(
          "حذف حسابي",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );

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
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Center(
                    child: Container(
                        padding: const EdgeInsets.all(30.0),
                        constraints: const BoxConstraints.expand(),
                        // decoration: const BoxDecoration(
                        //   image: DecorationImage(
                        //       image: AssetImage("./images/noborderwaves.png"),
                        //       fit: BoxFit.cover),
                        // ),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              titlePadding:
                                                  const EdgeInsets.all(0),
                                              title: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20)),
                                                    color: Color(0xffFF6B6B)),
                                                width: 300,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 25.0),
                                                  child: Text(
                                                    '! تحذير',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          255, 239, 235, 208),
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              scrollable: true,
                                              content: Container(
                                                child: Form(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'هل أنت متأكد من تسجيل الخروج؟',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Color(
                                                                      0xffFF6B6B)),
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      30),
                                                              child: Text(
                                                                'إلغاء',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20.0),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          ///////
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                await FirebaseAuth
                                                                    .instance
                                                                    .signOut();
                                                                EasyLoading
                                                                    .showSuccess(
                                                                        '!تم تسجيل الخروج بنجاح');
                                                                EasyLoading
                                                                    .dismiss();
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    '/registerview');
                                                              } catch (e) {
                                                                print(e);
                                                              }
                                                              // AuthController()
                                                              //     .logout();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Color(
                                                                      0xffFF6B6B)),
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      30),
                                                              child: Text(
                                                                'خروج',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 30,
                                    ),
                                    Text(
                                      'تسجيل الخروج',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          const Text(
                            '   الملف الشخصي ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 35,
                                color: Color.fromARGB(255, 71, 81, 80),
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          //here starts the text fields that the user will enter
                          !isloading
                              ? const Expanded(
                                  child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xffFF6B6B),
                                  ),
                                ))
                              : Expanded(
                                  child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Column(
                                          children: [
                                            //photo////////////////////////////////////////////////////////
                                            FutureBuilder<String>(
                                              future: _firebaseStorage
                                                  .ref()
                                                  .child(
                                                      'usersProfileImages/${_auth.currentUser?.email}')
                                                  .getDownloadURL(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                        ConnectionState.done ||
                                                    snapshot.data == null ||
                                                    snapshot.hasError) {
                                                  if (snapshot.data == null ||
                                                      snapshot.hasError) {
                                                    imageURL = null;
                                                  } else {
                                                    imageURL = snapshot.data;
                                                  }
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 14),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // const SizedBox(
                                                        //     height: 30),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ProfilePicture(
                                                              name: '',
                                                              radius: 31,
                                                              fontsize: 40,
                                                              img: imageURL,
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                            '+ أضف صورتك الشخصية',
                                                            style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontSize: 15,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        71,
                                                                        81,
                                                                        80),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                          onPressed: () async {
                                                            final pickedFile =
                                                                await picker.getImage(
                                                                    source: ImageSource
                                                                        .gallery);
                                                            print(
                                                                '**************************************');
                                                            print(
                                                                '**************************************');

                                                            print(pickedFile
                                                                ?.path);
                                                            imageURL =
                                                                pickedFile
                                                                    ?.path;
                                                            setState(() {
                                                              if (pickedFile !=
                                                                  null) {
                                                                _image = File(
                                                                    pickedFile
                                                                        .path);
                                                              } else {
                                                                print(
                                                                    'No image selected.');
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                      ],
                                                    ),
                                                  );
                                                }

                                                return const Center(
                                                  child: Text('يتم التحميل'),
                                                );
                                              },
                                            ),
                                            // const Text(
                                            //   '   أضف صورتك الشخصية+',
                                            //   textAlign: TextAlign.center,
                                            //   style: TextStyle(
                                            //       fontSize: 15,
                                            //       color: Color.fromARGB(
                                            //           255, 71, 81, 80),
                                            //       fontWeight: FontWeight.bold),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      // name
                                      label(inputLabel: 'الإسم'),
                                      TextInputField(
                                        initilVlue: userModel!.name,
                                        onCallBack: (v) {
                                          userModel!.name = v;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      //email
                                      label(inputLabel: 'البريد الإلكتروني'),
                                      TextInputField(
                                        enabled: false,
                                        initilVlue: userModel!.email,
                                        onCallBack: (v) {
                                          userModel!.email = v;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      //GENDER
                                      label(inputLabel: 'الجنس'),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 1, left: 250),
                                          child: DecoratedBox(
                                            decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 1.0,
                                                  style: BorderStyle.solid,
                                                  color: Color.fromARGB(
                                                      115, 60, 69, 69)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            )),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 4),
                                              child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  value: userModel!.gender ??
                                                      gender,
                                                  items: genders
                                                      .map((item) =>
                                                          DropdownMenuItem(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black54),
                                                              )))
                                                      .toList(),
                                                  onChanged: (item) => setState(
                                                        (() {
                                                          gender = item;
                                                          userModel!.gender =
                                                              item;
                                                        }),
                                                      )),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        height: 15,
                                      ),
                                      // birthdate
                                      label(inputLabel: 'تاريخ الميلاد'),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 1, left: 250),
                                          child: TextFormField(
                                            initialValue: userModel!.birthdate,
                                            onChanged: (v) {
                                              userModel!.birthdate = v;
                                            },
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54),
                                            //controller: _dateController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                //ENABLED BORDER: NOT CLICKED BY USER YET
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            115, 60, 69, 69)),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                //FOCUSED BORDER: CLICKED BY USER
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.amber,
                                                        width: 2),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                //labelText: "تاريخ الميلاد",
                                                hintText: "اختر سنة ميلادك",
                                                hintTextDirection:
                                                    TextDirection.rtl,
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20)),
                                            onTap: () async {
                                              // Below line stops keyboard from appearing
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                              DateTime? newDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      builder:
                                                          (BuildContext context,
                                                              Widget? child) {
                                                        return Theme(
                                                          data:
                                                              ThemeData.light()
                                                                  .copyWith(
                                                            primaryColor:
                                                                Colors.amber,
                                                            colorScheme:
                                                                ColorScheme.light(
                                                                    primary: Colors
                                                                        .amber),
                                                            buttonTheme:
                                                                ButtonThemeData(
                                                                    textTheme:
                                                                        ButtonTextTheme
                                                                            .primary),
                                                          ),
                                                          child: child!,
                                                        );
                                                      },
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime.now());
                                              //if Cancel
                                              if (newDate == null) return;
                                              //if OK
                                              // setState(() => date = newDate);
                                              // _dateController.text =
                                              //     intl.DateFormat.yMMMd().format(newDate);
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      label(inputLabel: 'كلمة المرور'),
                                      TextInputField(
                                        initilVlue: userModel!.password,
                                        onCallBack: (v) {
                                          userModel!.password = v;
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          updataButton,
                                          SizedBox(
                                            width: 30,
                                          ),
                                          cancelButton,
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      deleteButton,
                                    ],
                                  ),
                                ))
                        ]))))));
  }

  Future<void> lodProfile() async {
    await FirebaseFirestore.instance
        .collection('parent')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      userModel = UserModel.fromSnap(value);
      isloading = true;
      if (mounted) {
        setState(() {});
      }
    });
  }
}

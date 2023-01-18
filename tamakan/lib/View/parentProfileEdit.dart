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
import 'package:tamakan/View/parentProfileView.dart';
import 'package:tamakan/View/widgets/TextInputField.dart';
import 'package:tamakan/View/widgets/button_widget.dart';
import 'package:tamakan/View/widgets/labels.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';

class parentprofileEdit extends StatefulWidget {
  const parentprofileEdit({super.key});

  @override
  State<parentprofileEdit> createState() => _parentprofileEditState();
}

final List<String> genders = [
  'أنثى',
  'ذكر',
];
String? gender = 'أنثى';

class _parentprofileEditState extends State<parentprofileEdit> {
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
    final updataButton = ButtonWidget(
      fun: () async {
        AuthController().editProfile(userModel!.name, userModel!.email,
            userModel!.password, userModel!.gender, userModel!.birthdate);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => parentprofileview()));
        Navigator.pop(context);
      },
      buttonLabel: 'حفظ التعديلات',
      buttonColor: Color(0xff4ECDC4),
    );
    /*final updataButton = Material(
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
          "حفظ التعديلات",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );*/

    //cancel button
    /*
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
    */
//delete button
    final deleteButton = ButtonWidget(
      fun: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const deleteAccount()))
      },
      buttonLabel: 'حذف حسابي',
      buttonColor: Color(0xffFF6B6B),
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
                        child: Column(children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [],
                          ),
                          // const SizedBox(
                          //   height: 40,
                          // ),

                          Text(
                            'تعديل الملف الشخصي',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
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
                                      child: Center(
                                          child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 20,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 5),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            color: Colors.grey[300]!)
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
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
                                              right: 100, left: 100),
                                          child: DecoratedBox(
                                            decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 1.0,
                                                  style: BorderStyle.solid,
                                                  color: Color.fromARGB(
                                                      115, 0, 0, 0)),
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
                                              right: 100, left: 100),
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
                                                            115, 7, 7, 7)),
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
                                        obsecure: true,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),

                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     updataButton,
                                      //     SizedBox(
                                      //       width: 30,
                                      //     ),
                                      //     cancelButton,
                                      //   ],
                                      // ),
                                      updataButton,
                                      SizedBox(
                                        height: 15,
                                      ),
                                      deleteButton,
                                    ],
                                  ),
                                ))))
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

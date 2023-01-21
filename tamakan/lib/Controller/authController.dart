import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tamakan/Model/userModel.dart';
//import 'package:tamakan/View/learning_map.dart';
import 'package:tamakan/View/loginView.dart';

class AuthController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  UserModel? currentUser;

//
  late Rx<User?> _user;
  String _message = '';

  //for email
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  //for password
  bool isPasswordCompliant(String password, [int minLength = 8]) {
    if (password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));

    return hasDigits & hasUppercase & hasLowercase;
  }

  bool isPasswordCompliant2(String password, [int minLength = 8]) {
    if (password.length >= minLength) {
      return true;
    } else
      return false;
  }

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialView);
  }

  _setInitialView(User? user) {
    if (user != null) {
      //change LearningMap to parent home page----------------------
      //Get.offAll(() => const LearningMap());
    } else {
      const CircularProgressIndicator(color: Color.fromARGB(255, 154, 62, 16));
    }
  }

  //USER REGISTERATION
  Future<bool> register(
    String name,
    String email,
    String password,
    String password2,
    String? gender,
    String bDate,
  ) async {
    try {
      ////validation to birthdate
      if (bDate.isEmpty || bDate.trim().isEmpty) {
        EasyLoading.showError("الرجاء أدخال تاريخ الميلاد");
        return false;
      } else

      /// All good
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          bDate.isNotEmpty &&
          (password == password2)) {
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        UserModel user = UserModel(
            name: name,
            email: email.trim(),
            password: password,
            gender: gender,
            birthdate: bDate,
            uid: credential.user!.uid);

        await FirebaseFirestore.instance
            .collection('parent')
            .doc(credential.user!.email)
            .set(user.toJson());
        return true;
      } else {
        EasyLoading.showError('الرجاء إدخال جميع المعلومات المطلوبة بشكل صحيح');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          _message = 'البريد الإلكتروني مستخدم مسبقًا';
          break;
        case "invalid-email":
          _message = 'البريد الإلكتروني غير صالح';
          break;
        case "too-many-requests":
          _message = 'تم إرسال عدة طلبات';
          break;
        case "operation-not-allowed":
          _message = 'العملية غير مسموح بها';
          break;
        case "network-request-failed":
          _message = 'حصل خطأ خلال الاتصال بالشبكة';
          break;
        case "credential-already-in-use":
          _message = 'البيانات المدخلة مرتبطة بالفعل بحساب مستخدم مختلف';
          break;
        default:
          _message = 'الرجاء التحقق من إدخال جميع المعلومات المطلوبة بشكل صحيح';
          break;
      }
      EasyLoading.dismiss();
      EasyLoading.showError(_message);
      return false;
    }
  }

//USER LOGIN
  Future<bool> login(String email, String password) async {
    try {
      ///validation to email

      if (email.trim().isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          !password.trim().isEmpty) {
        UserCredential value = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.trim(), password: password.trim());
        // if (value != null) {
        //   return value;
        // }
        return true;
      } else {
        EasyLoading.showError(
            'الرجاء التحقق من إدخال جميع المعلومات المطلوبة بشكل صحيح');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          _message = 'البريد الالكتروني او كلمة المرور غير صحيحة';
          break;
        case "wrong-password":
          _message = 'البريد الالكتروني او كلمة المرور غير صحيحة';
          break;
        case "user-not-found":
          _message = "لايوجد مستخدم مسجل بهذا الحساب";
          break;
        case "too-many-requests":
          _message = 'تم إرسال عدة طلبات';
          break;
        case "operation-not-allowed":
          _message = 'العملية غير مسموح بها';
          break;
        case "network-request-failed":
          _message = 'حصل خطأ خلال الاتصال بالشبكة';
          break;
        case "credential-already-in-use":
          _message = 'بيانات الاعتماد هذه مرتبطة بالفعل بحساب مستخدم مختلف';
          break;
        default:
          _message = "الرجاء التحقق من إدخال البيانات";
          break;
      }
      EasyLoading.dismiss();
      EasyLoading.showError(_message);
      return false;
    }
    return false;
  }

//RESET PASSWORD
  Future resetpass(String email) async {
    try {
      EasyLoading.show(status: '..انتظر قليلًا');
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      EasyLoading.dismiss();
      EasyLoading.showSuccess(
          'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
      if (email != null) {
        //Get.toNamed("/loginview");
        // Get.toNamed(loginview.screenRoute);
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      EasyLoading.showError('الرجاء التحقق من صلاحية البريد الإلكتروني');
    }
  }

  //LOGOUT
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      EasyLoading.showSuccess('!تم تسجيل الخروج بنجاح');
      EasyLoading.dismiss();
      //Get.toNamed(welcomeView.screenRoute);
    } catch (e) {
      print(e);
    }
  }

  //Delete User Account
  final _firestone = FirebaseFirestore.instance;
  Future<void> deleteUser(String id) async {
    try {
      EasyLoading.show(status: '...انتظر قليلًا');
      await _firestone.collection('parent').doc(id).delete();

      EasyLoading.dismiss();
      EasyLoading.showSuccess('تم حذف الحساب بنجاح');
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('$e');
      print('err -> $e');
    }
  }

  // edit user profile
  void editProfile(
    String name,
    String email,
    String password,
    String? gender,
    String bDate,
  ) async {
    // UserModel? userModel;

    ///validation to name
    RegExp regexname = RegExp(r'^.{2,}$');

    if (name.isEmpty || name.trim().isEmpty)
      EasyLoading.showError("الرجاء أدخال الأسم");
    else if (!regexname.hasMatch(name)) {
      EasyLoading.showError("يجب ان يحتوي الأسم على حرفين على الأقل");
    } else if (!RegExp(r"^[\p{L} ,.'-]*$",
            caseSensitive: false, unicode: true, dotAll: true)
        .hasMatch(name)) {
      EasyLoading.showError("يجب ان يحتوي الأسم على أحرف فقط");
    } /*else if (name.length > 10) {
        EasyLoading.showError("الأسم المدخل غير صحيح");
      } */
    else

      ///validation to email

      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regexemail = RegExp(pattern.toString());

    if (email.isEmpty || email.trim().isEmpty) {
      EasyLoading.showError("الرجاء إدخال بريدك الإلكتروني");
    }

    if (!regexemail.hasMatch(email)) {
      EasyLoading.showError('بريدك الإلكتروني غير صحيح');
    } else
      ////////////////////////////////////////////////// validation to password
      RegExp regexpass = new RegExp(r'^.{8,}$');
    if (password.isEmpty || password.trim().isEmpty) {
      EasyLoading.showError("الرجاء تعيين كلمة مرور");
    }

    if (!isPasswordCompliant(password)) {
      EasyLoading.showError(
          'الرجاء إدخال كلمة مرور تحتوي على حرف كبير وصغير ورقم');
    } else if (!isPasswordCompliant2(password)) {
      EasyLoading.showError('    الرجاء إدخال كلمة مرور تحتوي على 8 خانات');
    } else
    ////validation to birthdate
    if (bDate.isEmpty || bDate.trim().isEmpty) {
      EasyLoading.showError("الرجاء أدخال تاريخ الميلاد");
    } else

    /// All good
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        bDate.isNotEmpty) {
      UserModel user = UserModel(
          name: name,
          email: email.trim(),
          password: password,
          gender: gender,
          birthdate: bDate,
          uid: FirebaseAuth.instance.currentUser!.uid);

      EasyLoading.show(status: '...رفع البيانات');
      await FirebaseFirestore.instance
          .collection('parent')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update(user.toJson())
          .then((value) {
        EasyLoading.showSuccess("تم التعديل بنجاح!");
      });
    }
  }
}

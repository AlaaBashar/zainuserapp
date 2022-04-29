import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'Fcm.dart';
import 'api.dart';

class Auth {
  Auth._();

  static UserApp? currentUser;

  static FirebaseAuth _auth = FirebaseAuth.instance;

  //create new user email/password
  static Future<UserApp?> signUpByEmailAndPass(
      {required UserApp userApp,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      userApp.uid = userCredential.user!.uid;
      return await Api.insertNewUser(
        userApp: userApp,
      );
    } on FirebaseAuthException catch (e) {
      //handle auth error
      if (e.code == "email-already-in-use") {
        return Future.error(
            'البريد الالكتروني مستخدم ، الرجاء اعادة استخدام بريد آخر');
      } else if (e.code == "invalid-email") {
        return Future.error('البريد الالكتروني غير صحيح');
      } else if (e.code == "weak-password") {
        return Future.error(
            "كلمة المرور ضعيفة ، يجب أن تكون كلمة المرور 6 أحرف على الأقل");
      } else {
        return Future.error('خطأ غير معروف يرجى المحاولة مرة أخرى لاحقًا');
      }
    } on PlatformException catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }

  static Future<UserApp?> loginByEmailAndPass(
      {String? email, String? password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email ?? '', password: password ?? '');

      return await Api.getUserFromUid(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return Future.error('لا يوجد سجل لهذا البريد الإلكتروني');
      }

      if (e.code == "invalid-email") {
        return Future.error('عنوان البريد الإلكتروني منسق بشكل سيئ');
      } else {
        return Future.error('البريد الالكتروني او كلمة المرور غير صحيحة');
      }
    }
  }

  static Future forgotPassword(String email) async {
    print('======== $email');
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return Future.error('لا يوجد سجل لهذا البريد الإلكتروني');
      }

      if (e.code == "invalid-email") {
        return Future.error('عنوان البريد الإلكتروني منسق بشكل سيئ');
      }
    }
  }

  static Future updateUserInPref(UserApp user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map userMap;

    userMap = user.toJson();

    String userJson = json.encode(userMap);

    currentUser = user;
    Fcm.subscribeToTopic(currentUser!.uid!);

    prefs.setString('User_Pref', userJson);
  }

  static Future removeUserFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('User_Pref');
  }

  static Future<UserApp?> getUserFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonUser;
    try {
      jsonUser = prefs.getString('User_Pref')!;
    } catch (e) {
      print('****** ${e.toString()}');
      return null;
    }
    Map<String, dynamic> userMap = json.decode(jsonUser);

    return UserApp.fromJson(userMap);
  }

  static Future logout() async {
    await _auth.signOut();
    Fcm.unSubscribeToTopic(currentUser!.uid!);
    removeUserFromPref();
    currentUser = null;
  }
}

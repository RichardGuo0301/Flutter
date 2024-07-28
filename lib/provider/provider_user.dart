import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/model/bean_user.dart';
import 'package:flutter_todo_list/utils/utils_logger.dart';

class UserProvider with ChangeNotifier {
  UserBean? _userBean;

  String get name => _userBean?.name ?? "";

  String get email => _userBean?.email ?? "";

  Future<bool> initUser() async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        return false;
      }
      var aa = await FirebaseFirestore.instance
          .collection("users")
          .where('uid', isEqualTo: uid)
          .get();
      var firstOrNull = aa.docs.firstOrNull;
      if (firstOrNull == null) {
        return false;
      }
      _userBean = UserBean.fromJson(firstOrNull.data());
      notifyListeners();
      return true;
    } catch (e) {
      LoggerUtils.e(e);
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      _userBean = null;
      notifyListeners();
      return true;
    } catch (e) {
      LoggerUtils.print(e);
    }
    return false;
  }

  Future<void> login(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    var user = credential.user;
    if (user == null) {
      throw Exception("login error user == null");
    }

    final aa = await FirebaseFirestore.instance
        .collection("users")
        .where('uid', isEqualTo: user.uid)
        .get();
    if (aa.size == 0) {
      var userBean =
          UserBean(uid: user.uid, name: '', email: email, password: password);

      await FirebaseFirestore.instance
          .collection("users")
          .add(userBean.toJson());
      _userBean = userBean;
    } else {
      var firstOrNull = aa.docs.firstOrNull;
      if (firstOrNull == null) {
        throw Exception("login error aa.docs.firstOrNull");
      }
      _userBean = UserBean.fromJson(firstOrNull.data());
    }
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    final res = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    var user = res.user;
    if (user == null) {
      throw Exception("register error user == null");
    }
    await _trySaveUserInfoToFireStore(
      UserBean(uid: user.uid, name: name, email: email, password: password),
    );
  }

  Future<void> _trySaveUserInfoToFireStore(UserBean user) async {
    try {
      await FirebaseFirestore.instance.collection("users").add(user.toJson());
    } catch (e) {
      LoggerUtils.e("_trySaveUserInfoToFireStore error:$e");
    }
  }
}

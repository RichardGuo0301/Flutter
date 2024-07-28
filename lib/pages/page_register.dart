import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/provider/provider_user.dart';
import 'package:flutter_todo_list/utils/utils_logger.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();

  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _pwdTextEditingController =
      TextEditingController();

  final TextEditingController _confirmPwdTextEditingController =
      TextEditingController();

  bool _showPwd = true;
  bool _showPwd2 = true;
  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _nameTextEditingController,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: false,
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.badge,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xff999999),
                      ),
                      hintText: "Your Name",
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _emailTextEditingController,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: false,
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xff999999),
                      ),
                      hintText: "Your Email",
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 15,
                    bottom: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _pwdTextEditingController,
                    obscureText: _showPwd,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: false,
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff999999),
                      ),
                      hintText: "Your Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPwd = !_showPwd;
                          });
                        },
                        icon: Icon(
                          _showPwd ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _confirmPwdTextEditingController,
                    obscureText: _showPwd2,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: false,
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff999999),
                      ),
                      hintText: "Confirm Your Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPwd2 = !_showPwd2;
                          });
                        },
                        icon: Icon(
                          _showPwd2 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 15),
                  child: FilledButton(
                    onPressed: () {
                      _submitData(context);
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _showLoading
              ? Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54,
                    ),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  void _submitData(BuildContext context) async {
    final name = _nameTextEditingController.text;
    if (name.isEmpty) {
      myShowDialog(context, "name is empty");
      return;
    }
    final email = _emailTextEditingController.text;
    if (email.isEmpty) {
      myShowDialog(context, "email is empty");
      return;
    }
    final password = _pwdTextEditingController.text;
    if (password.isEmpty) {
      myShowDialog(context, "password is empty");
      return;
    }

    if (password.length < 6) {
      myShowDialog(context, "password is length >= 6");
      return;
    }

    final confirmPassword = _confirmPwdTextEditingController.text;
    if (password != confirmPassword) {
      myShowDialog(context, "password and confirmPassword is not equal");
      return;
    }
    setState(() {
      _showLoading = true;
    });
    try {
      await context.read<UserProvider>().register(name, email, password);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      LoggerUtils.e(e);
      if (e.code == 'weak-password') {
        if (context.mounted) {
          myShowDialog(context, 'The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (context.mounted) {
          myShowDialog(context, 'The account already exists for that email.');
        }
      } else {
        if (context.mounted) {
          myShowDialog(context, "register error");
        }
      }
    } catch (e) {
      LoggerUtils.e(e);
      if (context.mounted) {
        myShowDialog(context, "register error");
      }
    } finally {
      setState(() {
        _showLoading = false;
      });
    }
  }


}

Future<dynamic> myShowDialog(
  BuildContext context,
  String content,
) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(content)],
        ),
      );
    },
  );
}

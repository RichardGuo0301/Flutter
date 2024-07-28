import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/home/page_home.dart';
import 'package:flutter_todo_list/pages/page_register.dart';
import 'package:flutter_todo_list/provider/provider_user.dart';
import 'package:flutter_todo_list/utils/utils_logger.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _pwdTextEditingController =
      TextEditingController();

  bool _showPwd = true;
  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8f8f8),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 15),
                    child: FilledButton(
                      onPressed: () => _submitData(context),
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, right: 15),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "New User?",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          TextSpan(
                            text: " Create Account",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) {
                                      return const RegisterPage();
                                    },
                                  ),
                                );
                              },
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
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
      ),
    );
  }

  void _submitData(BuildContext context) async {
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

    try {
      await context.read<UserProvider>().login(email, password);
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) {
              return const HomePage();
            },
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      LoggerUtils.e(e);
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          myShowDialog(context, "No user found for that email.");
        }
      } else if (e.code == 'wrong-password') {
        if (context.mounted) {
          myShowDialog(context, "Wrong password provided for that user.");
        }
      } else {
        if (context.mounted) {
          myShowDialog(context, "login error");
        }
      }
    } catch (e) {
      LoggerUtils.e(e);
      if (context.mounted) {
        myShowDialog(context, "login error");
      }
    } finally {
      setState(() {
        _showLoading = false;
      });
    }
  }
}

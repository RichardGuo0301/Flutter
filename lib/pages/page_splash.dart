import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/home/page_home.dart';
import 'package:flutter_todo_list/pages/page_login.dart';
import 'package:flutter_todo_list/provider/provider_user.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jump();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            "TODO",
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _jump() async {
    var res = await context.read<UserProvider>().initUser();
    if (mounted) {
      if (res) {
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(builder: (context) {
          return const HomePage();
        }));
      } else {
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(builder: (context) {
          return const LoginPage();
        }));
      }
    }
  }
}

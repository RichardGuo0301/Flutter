import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/pages/page_login.dart';
import 'package:flutter_todo_list/provider/provider_user.dart';
import 'package:provider/provider.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.account_circle,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                provider.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 10),
              child: Text(
                provider.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff666666),
                ),
              ),
            ),
            FilledButton(
              onPressed: () => _logout(context),
              child: const Text(
                "logout",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  _logout(BuildContext context) async {
    bool res = await context.read<UserProvider>().logout();
    if (res && context.mounted) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ),
      );
    }
  }
}

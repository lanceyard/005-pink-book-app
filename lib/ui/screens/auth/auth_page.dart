import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/screens/auth/login_page.dart';
import 'package:pink_book_app/ui/screens/history/history_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something occured, ${snapshot.error.toString()}");
          }

          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return const LoginPage();
            } else {
              return const HistoryPage();
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

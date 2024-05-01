import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pink_book_app/logic/bloc/auth/auth_bloc.dart';
import 'package:pink_book_app/logic/bloc/history/history_bloc.dart';
import 'package:pink_book_app/ui/screens/auth/login_page.dart';
import 'package:pink_book_app/ui/screens/history/history_page.dart';
import 'package:pink_book_app/ui/widget/Dialog/custom_alert_dialog.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  // [[ todo: stream authStateChanges() to bloc
  // but maybe its a little bit of work so idk ]]
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  title: Icons.info_outlined,
                  content: state.error,
                );
              });
        }
      },
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, snapshot) {
            context.read<HistoryBloc>().add(HistoryGetAllEvent());
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
          }),
    );
  }
}

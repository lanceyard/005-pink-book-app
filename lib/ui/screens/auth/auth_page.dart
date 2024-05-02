import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pink_book_app/logic/bloc/auth/auth_bloc.dart';
import 'package:pink_book_app/logic/bloc/history/history_bloc.dart';
import 'package:pink_book_app/ui/screens/auth/login_page.dart';
import 'package:pink_book_app/ui/screens/history/history_page.dart';
import 'package:pink_book_app/ui/widget/Dialog/custom_alert_dialog.dart';

// Halaman AuthPage dibuat sebagai StatefulWidget di mana kita menampilkan ui pengguna berdasarkan status auth pengguna. Kita menggunakan BlocListener untuk mendengarkan perubahan status auth dari AuthBloc, dan jika terjadi error auth (AuthError), kita tampilkan dialog dengan pesan kesalahan. Selain itu, kita juga menggunakan StreamBuilder untuk memantau perubahan status auth dari FirebaseAuth, di mana kita menampilkan halaman login jika pengguna tidak terotentikasi, dan halaman riwayat jika pengguna sudah terotentikasi. Jika terjadi kesalahan dalam pengambilan status otentikasi, kita tampilkan pesan kesalahan tersebut.

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

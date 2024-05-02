import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pink_book_app/logic/bloc/auth/auth_bloc.dart';
import 'package:pink_book_app/logic/bloc/history/history_bloc.dart';
import 'package:pink_book_app/logic/bloc/history_action/history_action_bloc.dart';
import 'package:pink_book_app/ui/screens/auth/auth_page.dart';
import 'package:pink_book_app/ui/screens/auth/login_page.dart';
import 'package:pink_book_app/ui/screens/auth/register_page.dart';
import 'package:pink_book_app/ui/screens/history/history_page.dart';
import 'package:pink_book_app/ui/screens/history/input_page.dart';
import 'package:pink_book_app/ui/screens/result/result_page.dart';
import 'package:pink_book_app/ui/widget/theme/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // [[ Provide auth bloc. kalo dianalogiin; widget tree kan dari atas turun ke bawah,
    // misal ini material app, isinya ada scaffold, lalu scaffold isinya page ini itu
    // nah providing bloc itu kaya nuangin aer. auth bloc ditaroh sini biar bisa kena semua ]]
    return MultiBlocProvider(
      providers: [
      BlocProvider(
        create: (context) => AuthBloc()),
      BlocProvider(
        create: (context) => HistoryBloc()),
      BlocProvider(
        create: (context) => HistoryActionBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        routes: {
          '/': (context) => const AuthPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/history': (context) => const HistoryPage(),
          '/input': (context) => const InputPage(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pink_book_app/widget/button/filled_button.dart';
import 'package:pink_book_app/widget/button/outlined_button.dart';
import 'package:pink_book_app/widget/button/text_button.dart';
import 'package:pink_book_app/widget/field/field.dart';
import 'package:pink_book_app/widget/theme/color_theme.dart';
import 'package:pink_book_app/widget/theme/text_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/welcome.png"),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Welcome Back,',
                    style: headerTextStyle.copyWith(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Login with a registered account',
                    style: subHeaderTextStyle.copyWith(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputField(
                    controller: emailController,
                    // isLoading digunakan untuk pengecekan api
                    isLoading: isLoading,
                    keyType: TextInputType.emailAddress,
                    hint: 'Input Username',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'The Name column must be filled in';
                      }
                      return null;
                    },
                    prefixIcon: Icons.mail,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  InputField(
                    isLoading: isLoading,
                    controller: passwordController,
                    prefixIcon: Icons.key,
                    hint: 'Input Password',
                    isPassword: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'The Password field must be filled in';
                      }
                      if (val.length < 8) {
                        return 'Password must be 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          "Doesn't have account yet? you can ",
                          style: subHeaderTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        CustomTextButton(
                          text: 'Register ',
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/register', (route) => false);
                          },
                        ),
                        Text(
                          "first!",
                          style: subHeaderTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFilledButton(
                    title: 'SIGN IN',
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    bgColor: basePinkColor,
                    hvColor: oldRedColor,
                    onPresssed: () {
                      if (_formKey.currentState!.validate()) {
                        // Navigator.pushNamed(context, '/register');
                        print("lol");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Text(
                      'OR',
                      style: subHeaderTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomOutlinedButton(
                    logo: "assets/google_logo.png",
                    title: 'SIGN IN WITH GOOGLE',
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    hvColor: shadePinkColor,
                    bgColor: basePinkColor,
                    onPresssed: () {},
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  Center(
                    child: Text(
                      'by BIMA ANGGARA WIRASATYA',
                      style: headerTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: greyColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pink_book_app/widget/button/filled_button.dart';
import 'package:pink_book_app/widget/button/outlined_Button.dart';
import 'package:pink_book_app/widget/button/text_button.dart';
import 'package:pink_book_app/widget/field/field.dart';
import 'package:pink_book_app/widget/theme/color_theme.dart';
import 'package:pink_book_app/widget/theme/text_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                  Image.asset("assets/wellcome.png"),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Wellcome,",
                    style: headerTextStyle.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Stay informed, stay healthy! Register now to track your health',
                    style: subHeaderTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputField(
                    controller: usernameController,
                    isLoading: isLoading,
                    prefixIcon: Icons.person,
                    hint: 'Input Username',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'The Name column must be filled in';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  InputField(
                    controller: emailController,
                    isLoading: isLoading,
                    keyType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail,
                    hint: 'Input E-mail',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'The E-mail field must be filled in';
                      }
                      if (!val.contains('@')) {
                        return 'Invalid E-mail';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  InputField(
                    controller: passwordController,
                    isLoading: isLoading,
                    prefixIcon: Icons.key,
                    isPassword: true,
                    hint: 'Input Password',
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
                  InputField(
                    controller: confirmPasswordController,
                    isLoading: isLoading,
                    prefixIcon: Icons.key,
                    isPassword: true,
                    hint: 'Input Password',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'The Confirm Password column must be filled in';
                      }
                      if (val != passwordController.text) {
                        return 'Password and Confirm password must be the same';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomFilledButton(
                    title: 'SIGN UP',
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    bgColor: basePinkColor,
                    hvColor: oldRedColor,
                    onPresssed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, "/");
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
                    title: 'SIGN UP WITH GOOGLE',
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    hvColor: shadePinkColor,
                    bgColor: basePinkColor,
                    onPresssed: () {},
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          "Already have account? you can ",
                          style: subHeaderTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        CustomTextButton(
                          text: 'Login here ',
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          },
                        ),
                        Text(
                          "to enter!",
                          style: subHeaderTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

class InputField extends StatefulWidget {
  const InputField(
      {super.key,
      required this.isLoading,
      this.prefixIcon,
      this.hint,
      this.label,
      this.keyType,
      this.maxLenght,
      this.isPassword,
      this.validator,
      this.controller});

  final bool isLoading;
  final IconData? prefixIcon;
  final String? hint;
  final String? label;
  final TextInputType? keyType;
  final int? maxLenght;
  final bool? isPassword;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  var textLength = 0;

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscuringCharacter: '*',
      keyboardType: widget.keyType,
      enabled: !widget.isLoading,
      cursorColor: oldRedColor,
      maxLength: widget.maxLenght,
      obscureText: widget.isPassword == true ? !showPassword : false,
      decoration: InputDecoration(
        suffixText:
            widget.maxLenght != null ? '$textLength/${widget.maxLenght}' : null,
        suffixIcon: widget.isPassword == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: oldRedColor,
                ),
              )
            : null,
        counterText: '',
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: Container(
          width: 50,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: oldRedColor),
          child: Icon(
            widget.prefixIcon,
            color: Colors.white,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: oldRedColor),
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: oldRedColor),
            borderRadius: BorderRadius.circular(10)),
        hintText: widget.hint,
        hintStyle: hintTextStyle,
        labelText: widget.label,
        labelStyle: hintTextStyle,
      ),
      onChanged: (val) {
        setState(() {
          textLength = val.length;
        });
      },
    );
  }
}

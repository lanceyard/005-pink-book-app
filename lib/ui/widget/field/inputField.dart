import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

class DataInputFIeld extends StatefulWidget {
  const DataInputFIeld(
      {super.key,
      required this.isLoading,
      this.hint,
      this.label,
      this.keyType,
      this.maxLenght,
      this.isPassword,
      this.validator,
      this.controller});

  final bool isLoading;
  final String? hint;
  final String? label;
  final TextInputType? keyType;
  final int? maxLenght;
  final bool? isPassword;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  State<DataInputFIeld> createState() => _InputFieldState();
}

class _InputFieldState extends State<DataInputFIeld> {
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

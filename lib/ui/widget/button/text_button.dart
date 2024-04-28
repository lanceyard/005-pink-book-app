import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const CustomTextButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Text(
        text,
        style: buttonTextStyle.copyWith(
          color: basePinkColor,
          fontSize: 16,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pink_book_app/widget/theme/text_theme.dart';

class CustomFilledButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final VoidCallback? onPresssed;

  final Color? bgColor;
  final Color? hvColor;

  const CustomFilledButton(
      {super.key,
      required this.title,
      required this.width,
      required this.height,
      this.onPresssed,
      this.bgColor,
      this.hvColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: hvColor,
          borderRadius: BorderRadius.circular(10),
          onTap: onPresssed,
          child: Center(
            child: Text(
              title,
              style: buttonTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

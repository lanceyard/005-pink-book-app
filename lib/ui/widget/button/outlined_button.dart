import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';

import '../theme/text_theme.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  final String? logo;
  final Color bgColor;
  final Color? hvColor;
  const CustomOutlinedButton(
      {super.key,
      required this.title,
      required this.width,
      required this.height,
      this.onPressed,
      required this.bgColor,
      this.hvColor,
      this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: bgColor,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: hvColor,
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (logo != null &&
                  logo!
                      .isNotEmpty) // Periksa apakah logo tidak null atau kosong
                Image.asset(
                  logo!,
                  width: 24,
                  height: 24,
                ),
              const SizedBox(
                width: 6,
              ),
              Text(
                title,
                style: buttonTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: oldRedColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

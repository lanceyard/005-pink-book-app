import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/widget/button/filled_button.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
  });

  final IconData? title;
  final String? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Icon(
        title,
        color: oldRedColor,
        size: 30,
      ),
      content: Text(
        '$content',
        style: subHeaderTextStyle.copyWith(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: actions ??
          [
            CustomFilledButton(
              hvColor: shadePinkColor,
              bgColor: oldRedColor,
              title: 'OK',
              width: 100,
              height: 40,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
    );
  }
}

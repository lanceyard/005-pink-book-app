import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/widget/Dialog/custom_alert_dialog.dart';

showImage(String path) {
  if (!path.contains("http")) {
    return Image.file(
      File(path),
      width: 150,
      height: 150,
      fit: BoxFit.cover,
    );
  } else {
    return Image.network(path, width: 150, height: 150, fit: BoxFit.cover);
  }
}

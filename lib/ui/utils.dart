import 'dart:io';

import 'package:flutter/material.dart';

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

String extractDatetime(String dateTimeString, String choice) {
  List<String> parts = dateTimeString.split(' ');
  String date = parts[0];
  String time = parts[1];

  if (choice.toLowerCase() == 'date') {
    return date;
  } else if (choice.toLowerCase() == 'time') {
    return time;
  } else {
    return "Wrong choice";
  }
}

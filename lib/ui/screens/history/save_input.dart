import 'package:flutter/material.dart';

class SaveHistory extends StatelessWidget {
  const SaveHistory({super.key, required this.ogttTest, required this.oximeterTest, required this.stomachDiameter, required this.weightGain, required this.momsAge, required this.alcoholTest, required this.pregnancyAge, required this.imagePaths, required this.additionalNotes});

    final int ogttTest;
  final int oximeterTest;
  final int stomachDiameter;
  final int weightGain;
  final int momsAge;
  final String alcoholTest;
  final int pregnancyAge;
  final List<String> imagePaths;
  final String additionalNotes;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
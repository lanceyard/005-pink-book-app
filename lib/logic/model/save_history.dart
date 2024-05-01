class SaveHistory {
  const SaveHistory(
      {required this.ogttTest,
      required this.oximeterTest,
      required this.stomachDiameter,
      required this.weightGain,
      required this.momsAge,
      required this.alcoholTest,
      required this.pregnancyAge,
      required this.imagePaths,
      required this.additionalNotes,
      this.date = '',
      this.uid = ''});

  final int ogttTest;
  final int oximeterTest;
  final int stomachDiameter;
  final int weightGain;
  final int momsAge;
  final String alcoholTest;
  final int pregnancyAge;
  final List<String> imagePaths;
  final String additionalNotes;
  final String uid;
  final String date;

  factory SaveHistory.fromMap(Map<String, dynamic> map) {
    return SaveHistory(
      ogttTest: map['ogttTest'] ?? 0,
      oximeterTest: map['oximeterTest'] ?? 0,
      stomachDiameter: map['stomachDiameter'] ?? 0,
      weightGain: map['weightGain'] ?? 0,
      momsAge: map['momsAge'] ?? 0,
      alcoholTest: map['alcoholTest'] ?? '',
      pregnancyAge: map['pregnancyAge'] ?? 0,
      imagePaths: List<String>.from(map['imagePaths'] ?? []),
      additionalNotes: map['additionalNotes'] ?? '',
      date: map['date'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  Map<String, dynamic> toMap(SaveHistory history) {
    return {
      'ogttTest': history.ogttTest,
      'oximeterTest': history.oximeterTest,
      'stomachDiameter': history.stomachDiameter,
      'weightGain': history.weightGain,
      'momsAge': history.momsAge,
      'alcoholTest': history.alcoholTest,
      'pregnancyAge': history.pregnancyAge,
      'imagePaths': history.imagePaths,
      'additionalNotes': history.additionalNotes,
      'uid': history.uid,
      'date': history.date,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pink_book_app/logic/model/save_history.dart';
import 'package:pink_book_app/ui/utils.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

// class ResultPage adalah halaman yang menampilkan hasil dari data yang dimasukkan pengguna sebelumnya. Informasi yang ditampilkan meliputi hasil dari tes OGTT, tes alkohol, penambahan berat badan, dan tes oksimeter. Selain itu, halaman ini juga menampilkan saran berdasarkan hasil tes dan persentase deteksi.
class ResultPage extends StatefulWidget {
  final SaveHistory saveHistory;
  const ResultPage({super.key, required this.saveHistory});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<String> suggestions = [];
  List<XFile> imageFileList = [];
  int normalTests = 0;
  double normalPercentage = 0;

  bool isOgttNormal = false;
  bool isAlcoholNormal = false;
  bool isOximeterNormal = false;
  bool isWeightNormal = false;

  @override
  void initState() {
    super.initState();
    imageFileList =
        widget.saveHistory.imagePaths.map((path) => XFile(path)).toList();
    if (widget.saveHistory.ogttTest >= 140 &&
        widget.saveHistory.ogttTest <= 190) {
      isOgttNormal = true;
      addSuggestion('Your Blood Test is Normal !', true);
    } else if (widget.saveHistory.ogttTest > 190) {
      addSuggestion(
          'We suggest you to eat healthy food and try to reduce sugar consumption to make sure your infant is healthy!',
          false);
    } else {
      addSuggestion(
          'We suggest you to eat some high sugar food to make sure your blood is normal, it will affect your infant health!',
          false);
    }

    if (widget.saveHistory.alcoholTest == 'Negative') {
      isAlcoholNormal = true;
    } else if (widget.saveHistory.alcoholTest == 'Positive') {
      addSuggestion(
          'We suggest you to Reduce Alcohol Consumption since alcohol is bad for infant and can lead to bigger problem !',
          false);
    }

    if (widget.saveHistory.oximeterTest >= 95 &&
        widget.saveHistory.oximeterTest <= 100) {
      isOximeterNormal = true;
      addSuggestion('Your Oximeter Test is Normal!', true);
    } else {
      addSuggestion(
          'We suggest you to avoid some smokes including vape or cigarettes it will cause your infant unhealthy.',
          false);
    }

    if (widget.saveHistory.weightGain >= 18 &&
        widget.saveHistory.weightGain <= 25) {
      isWeightNormal = true;
      addSuggestion('Your Weight is Normal!', true);
    } else if (widget.saveHistory.weightGain < 18) {
      addSuggestion(
          'We suggest you to eat more food to gain some weight it will affect your infant health.',
          false);
    } else {
      addSuggestion(
          'We suggest you to reduce your weight with some safe healthy diet for pregnant women, because it will affect your infant health.',
          false);
    }

    normalTests = (isOgttNormal ? 1 : 0) +
        (isAlcoholNormal ? 1 : 0) +
        (isOximeterNormal ? 1 : 0) +
        (isWeightNormal ? 1 : 0);

    normalPercentage = (normalTests / 4) * 100;
  }

  void addSuggestion(String suggestion, bool isNormal) {
    setState(() {
      suggestions.add('$suggestion#${isNormal ? 'normal' : 'abnormal'}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: shadePinkColor,
        title: Text(
          'RESULT',
          style: titleTextStyle.copyWith(
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'DATA REESULT',
                      style: titleTextStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Here is your result data, you can give this information to the expert if possible to get some advice, note that this data is not 100% true, so don’t panic and go see the expert if needed. Thanks for using PINK BOOK APP',
                    style: subHeaderTextStyle.copyWith(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                      child: DataTable(columns: const [
                    DataColumn(label: Text('Test')),
                    DataColumn(label: Text('Data')),
                    DataColumn(label: Text('Result')),
                  ], rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text("OGTT")),
                        DataCell(Text(widget.saveHistory.ogttTest.toString())),
                        DataCell(
                          Icon(
                            isOgttNormal ? Icons.check_circle : Icons.cancel,
                            color: isOgttNormal ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Alcohol")),
                        DataCell(Text(widget.saveHistory.alcoholTest)),
                        DataCell(
                          Icon(
                            isAlcoholNormal ? Icons.check_circle : Icons.cancel,
                            color: isAlcoholNormal ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Weight")),
                        DataCell(
                            Text(widget.saveHistory.weightGain.toString())),
                        DataCell(
                          Icon(
                            isWeightNormal ? Icons.check_circle : Icons.cancel,
                            color: isWeightNormal ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Oximeter")),
                        DataCell(
                            Text(widget.saveHistory.oximeterTest.toString())),
                        DataCell(
                          Icon(
                            isOximeterNormal
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: isOximeterNormal ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    )
                  ])),
                  const SizedBox(height: 16),
                  //! Ini output sugestion
                  //! TO Do
                  //? Warnanya retard merah merah semua hijau hijau semua bad my logic
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: suggestions.map((suggestion) {
                      final splitted = suggestion.split("#");
                      final suggestionText = splitted[0];
                      final isNormal = splitted[1] == 'normal';
                      return Text(
                        suggestionText,
                        style: TextStyle(
                          color: isNormal ? Colors.green : Colors.red,
                          fontSize: 14,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //! output persentase retard
                  Text(
                    'Autism Detection Result : ${normalPercentage.toStringAsFixed(0)}%',
                    style: titleTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '100% is Save, 75% is Quite Save, 50% is Bad, <25% is Really Bad',
                    style: subHeaderTextStyle.copyWith(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Notes :',
                    style: titleTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  //! output notes belum tau bakal gimana manggilnya jadi make text dummy dulu
                  Text(
                    'No additional notes in here',
                    style: subHeaderTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Picture :',
                    style: titleTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  //! ini sama udah ku siapin make image.network kalo manggil dari api
                  imageFileList.isEmpty
                      ? const Text('No image attached here')
                      : GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 6,
                                  crossAxisSpacing: 6,
                                  crossAxisCount: 3),
                          itemCount: imageFileList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return showImage(imageFileList[index].path);
                          },
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

//? Dummy Data
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> resultData = [
      {
        'Test': 'OGTT',
        'Data': 180,
      },
      {
        'Test': 'Alcohol',
        'Data': 'Positive',
      },
      {
        'Test': 'Weight',
        'Data': 50,
      },
      {
        'Test': 'Oximeter',
        'Data': 95,
      },
    ];


    List<String> suggestions = [];
    List<String> imageList = [];

    int normalTests = 0;

    // Logic for checking test results and generating suggestions
    for (int i = 0; i < resultData.length; i++) {
      final testName = resultData[i]['Test'];
      final testData = resultData[i]['Data'];
      bool isNormal = false;

      if (!isNormal) {
        if (testName == 'OGTT') {
          if (testData! >= 140 && testData <= 190) {
            isNormal = true;
            suggestions.add('Your Blood Test is Normal !');
          } else if (testData > 190) {
            suggestions.add(
                'We suggest you to eat healthy food and try to reduce sugar consumption to make sure your infant is healthy!');
          } else {
            suggestions.add(
                'We suggest you to eat some high sugar food to make sure your blood is normal, it will affect your infant health!');
          }
        } else if (testName == 'Alcohol' && testData == 'Negative') {
          isNormal = true;
        } else if (testName == 'Alcohol' && testData == 'Positive') {
          suggestions.add(
              'We Sugest you to Reduce Alcohol Consumption since alcohol is bad for infant and can lead to bigger problem !');
        } else if (testName == 'Oximeter') {
          if (testData! >= 95 && testData <= 100) {
            isNormal = true;
            suggestions.add('Your Oximeter Test is Normal !');
          } else {
            suggestions.add(
                'We suggest you to avoid some smokes including vape or cigarettes it will cause your infant unhealthy.');
          }
          //! Ini weight nya kenapa sampe 25 ?
        } else if (testName == 'Weight') {
          if (testData! >= 18 && testData <= 25) {
            isNormal = true;
            suggestions.add('Your Weight is Normal !');
          } else if (testData < 18) {
            suggestions.add(
                'We suggest you to eat more food to gain some weight it will affect your infant health.');
          } else {
            suggestions.add(
                'We suggest you to reduce your weight with some safe healthy diet for pregnant women, because it will affect your infant health.');
          }
        }
      }
      if (isNormal) {
        normalTests++;
      }
    }

//! Ini untuk mengetahui berapa percent retardnya:v
    double normalPercentage = (normalTests / resultData.length) * 100;

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
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Test')),
                        DataColumn(label: Text('Data')),
                        DataColumn(label: Text('Result')),
                      ],
                      rows: List.generate(
                        resultData.length,
                        (index) {
                          //! ini logic buat iconya
                          final testName = resultData[index]['Test'];
                          final testData = resultData[index]['Data'];
                          bool isNormal = false;

                          if (testName == 'OGTT') {
                            isNormal = testData! >= 140 && testData <= 190;
                          } else if (testName == 'Alcohol') {
                            isNormal = testData == 'Negative';
                          } else if (testName == 'Oximeter') {
                            isNormal = testData! >= 95 && testData <= 100;
                          } else if (testName == 'Weight') {
                            isNormal = testData! >= 18 && testData <= 25;
                          }

                          return DataRow(
                            cells: [
                              DataCell(Text(resultData[index]['Test']!)),
                              DataCell(
                                  Text(resultData[index]['Data'].toString())),
                              DataCell(
                                Icon(
                                  isNormal ? Icons.check_circle : Icons.cancel,
                                  color: isNormal ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  //! Ini output sugestion 
                  //! TO Do 
                  //? Warnanya retard merah merah semua hijau hijau semua bad my logic
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: suggestions.map((suggestion) {
                      return Text(
                        suggestion,
                        style: TextStyle(
                          color: suggestions.isNotEmpty
                              ? Colors.red
                              : Colors.green,
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
                    'Nothing Notes in here',
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
                  imageList.isEmpty
                      ? const Text('No Images here')
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network('');
                          })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pink_book_app/widget/theme/color_theme.dart';
import 'package:pink_book_app/widget/theme/text_theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  //? Dummy Data
  final List<Map<String, String>> _historyData = [
    {
      'Date': '2024-04-25',
      'Month': 'April',
      'Time': '10:00 AM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-20',
      'Month': 'April',
      'Time': '02:00 PM',
    },
    {
      'Date': '2024-04-25',
      'Month': 'April',
      'Time': '10:00 AM',
    },
    {
      'Date': '2024-04-25',
      'Month': 'April',
      'Time': '10:00 AM',
    },
    {
      'Date': '2024-04-25',
      'Month': 'April',
      'Time': '10:00 AM',
    },
    {
      'Date': '2024-04-25',
      'Month': 'April',
      'Time': '10:00 AM',
    },
    {
      'Date': '2024-04-25',
      'Month': 'April',
      'Time': '10:00 AM',
    },
    {
      'Date': '2024-04-25',
      'Month': 'April',
      'Time': '10:00 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: shadePinkColor,
        title: Text(
          'HIUSER!',
          style: titleTextStyle.copyWith(
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'History Database',
                  style: titleTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  'Here is history of your recorded data, you can either see it, watch it, edit it or even delete the data or even add a new one, all the data that input to this record should be done correctly by the experts.',
                  style: subHeaderTextStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(shadePinkColor),
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Month')),
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: List.generate(
                      _historyData.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(Text(_historyData[index]['Date']!)),
                          DataCell(Text(_historyData[index]['Month']!)),
                          DataCell(Text(_historyData[index]['Time']!)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  iconSize: 16.0,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.save,
                                    color: basePinkColor,
                                  ),
                                ),
                                IconButton(
                                  iconSize: 16.0,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit,
                                    color: basePinkColor,
                                  ),
                                ),
                                IconButton(
                                  iconSize: 16.0,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    color: basePinkColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: basePinkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.0),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

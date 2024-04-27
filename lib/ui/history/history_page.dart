import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pink_book_app/widget/theme/color_theme.dart';
import 'package:pink_book_app/widget/theme/text_theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

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
          actions: [
          IconButton(onPressed: () async {
          await GoogleSignIn().signOut();
          FirebaseAuth.instance.signOut();
          }, icon: const Icon(Icons.logout))
          ],
          backgroundColor: shadePinkColor,
          title: Text(
            'HI USER!',
            style: titleTextStyle.copyWith(
              fontSize: 24,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                      headingRowColor:
                          MaterialStateProperty.all(shadePinkColor),
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   backgroundColor: basePinkColor,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(26.0),
        //   ),
        //   child: const Icon(
        //     Icons.add,
        //     color: Colors.white,
        //     size: 40,
        //   ),
        // ),
        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title: "Input Data",
              iconColor: Colors.white,
              bubbleColor: basePinkColor,
              icon: Icons.add,
              titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
              onPress: () {
                _animationController.reverse();
              },
            ),
            // Floating action menu item
            Bubble(
              title: "See Results",
              iconColor: Colors.white,
              bubbleColor: basePinkColor,
              icon: Icons.assignment,
              titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
              onPress: () {
                _animationController.reverse();
              },
            ),
          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),

          // Floating Action button Icon color
          iconColor: Colors.white,

          // Flaoting Action button Icon
          iconData: Icons.menu,
          backGroundColor: basePinkColor,
        ));
  }
}

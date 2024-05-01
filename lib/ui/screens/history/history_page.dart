import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pink_book_app/logic/bloc/auth/auth_bloc.dart';
import 'package:pink_book_app/logic/model/save_history.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

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
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

		getHistoryDocuments();
  }

  getHistoryDocuments() async {
    try {
      final currentUid = FirebaseAuth.instance.currentUser!.uid;
      final collection = FirebaseFirestore.instance.collection('histories');
      final querySnapshot =
          await collection.where('uid', isEqualTo: currentUid).get();
      _historyData.clear();
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final SaveHistory sH = SaveHistory.fromMap(data);
        setState(() {
          _historyData.add(sH);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //? Dummy Data
  final List<SaveHistory> _historyData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  const snackBar = SnackBar(
                    content: Text('PINK BOOK APP by BIMA ANGGARA WIRASATYA!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: const Icon(Icons.info)),
            IconButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(UserAuthLogout());
                },
                icon: const Icon(Icons.logout))
          ],
          backgroundColor: shadePinkColor,
          title: Text(
            'HI ${FirebaseAuth.instance.currentUser?.displayName ?? "User"}!',
            style: titleTextStyle.copyWith(
              fontSize: 24,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                            // put it here
                            DataCell(Text(_historyData[index].date)),
                            DataCell(Text(
                                _historyData[index].pregnancyAge.toString())),
                            DataCell(Text(_historyData[index].date)),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    iconSize: 16.0,
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.assignment,
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
                Navigator.pushNamed(context, '/input');
              },
            ),
            Bubble(
              title: "See Firebase",
              iconColor: Colors.white,
              bubbleColor: basePinkColor,
              icon: Icons.refresh,
              titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
              onPress: () {
                getHistoryDocuments();
              },
            ),
            // Floating action menu item
            // Bubble(
            //   title: "See Results",
            //   iconColor: Colors.white,
            //   bubbleColor: basePinkColor,
            //   icon: Icons.assignment,
            //   titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
            //   onPress: () {
            //     _animationController.reverse();
            //     Navigator.pushNamed(context, '/result');
            //   },
            // ),
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

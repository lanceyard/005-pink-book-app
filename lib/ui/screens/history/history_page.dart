import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pink_book_app/logic/bloc/auth/auth_bloc.dart';
import 'package:pink_book_app/logic/bloc/history_action/history_action_bloc.dart';
import 'package:pink_book_app/logic/model/save_history.dart';
import 'package:pink_book_app/ui/widget/Dialog/custom_alert_dialog.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

//! TO DO
//* Tinggal buton edit sama delete

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  int _sortColumnIndex = 0;
  bool _isAscending = true;
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

  Future<void> refreshData() async {
    // Tambahkan penundaan 2 detik
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      //! ini kalo mau ditambah loading beb
      // isLoading = true;
    });
    await getHistoryDocuments();
    setState(() {
      // isLoading = false;
    });
  }

  //? Dummy Data
  final List<SaveHistory> _historyData = [];

  void _sort<T>(Comparable<T> Function(SaveHistory sh) getField,
      int columnIndex, bool ascending) {
    _historyData.sort((SaveHistory a, SaveHistory b) {
      if (!ascending) {
        final SaveHistory c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryActionBloc, HistoryActionState>(
        listener: (context, state) {
        if(state is HistoryActionSuccess){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomAlertDialog(
                  title: Icons.info_outlined,
                  content: "History Input Saved!",
                );
              });
        }

        if(state is HistoryActionError){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  title: Icons.info_outlined,
                  content: state.msg,
                );
              });
        }
        },
        child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      refreshData();
                    },
                    icon: const Icon(Icons.refresh)),
                IconButton(
                    onPressed: () async {
                      const snackBar = SnackBar(
                        content:
                            Text('PINK BOOK APP by BIMA ANGGARA WIRASATYA!'),
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
                      const SizedBox(
                        height: 16,
                      ),
                      _historyData.isEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Center(
                                child: Text(
                                  'The data history is still empty, please fill in the data first.',
                                  style: subHeaderTextStyle.copyWith(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                sortColumnIndex: _sortColumnIndex,
                                sortAscending: _isAscending,
                                headingRowColor:
                                    MaterialStateProperty.all(shadePinkColor),
                                columns: [
                                  DataColumn(
                                    label: const Text('Date'),
                                    onSort: (columnIndex, ascending) =>
                                        _sort<String>(
                                            (SaveHistory sh) => sh.date,
                                            columnIndex,
                                            ascending),
                                  ),
                                  DataColumn(
                                    label: const Text('Month'),
                                    onSort: (columnIndex, ascending) =>
                                        _sort<String>(
                                            (SaveHistory sh) =>
                                                sh.pregnancyAge.toString(),
                                            columnIndex,
                                            ascending),
                                  ),
                                  DataColumn(
                                    label: const Text('Time'),
                                    onSort: (columnIndex, ascending) =>
                                        _sort<String>(
                                            (SaveHistory sh) => sh.date,
                                            columnIndex,
                                            ascending),
                                  ),
                                  const DataColumn(label: Text('Action')),
                                ],
                                rows: List.generate(
                                  _historyData.length,
                                  (index) => DataRow(
                                    cells: [
                                      // put it here
                                      DataCell(Text(_historyData[index].date)),
                                      DataCell(Text(_historyData[index]
                                          .pregnancyAge
                                          .toString())),
                                      DataCell(Text(_historyData[index].date)),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              iconSize: 16.0,
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/result');
                                              },
                                              icon: Icon(
                                                Icons.assignment,
                                                color: basePinkColor,
                                              ),
                                            ),
                                            IconButton(
                                              iconSize: 16.0,
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/input');
                                              },
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
                  titleStyle:
                      const TextStyle(fontSize: 14, color: Colors.white),
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
                  titleStyle:
                      const TextStyle(fontSize: 14, color: Colors.white),
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
            )));
  }
}

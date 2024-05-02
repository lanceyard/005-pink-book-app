import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pink_book_app/logic/bloc/auth/auth_bloc.dart';
import 'package:pink_book_app/logic/bloc/history/history_bloc.dart';
import 'package:pink_book_app/logic/bloc/history_action/history_action_bloc.dart';
import 'package:pink_book_app/logic/model/save_history.dart';
import 'package:pink_book_app/ui/screens/history/input_page.dart';
import 'package:pink_book_app/ui/screens/result/result_page.dart';
import 'package:pink_book_app/ui/utils.dart';
import 'package:pink_book_app/ui/widget/Dialog/custom_alert_dialog.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

// Kode ini adalah halaman riwayat dalam aplikasi, di mana pengguna dapat melihat riwayat data yang telah mereka rekam sebelumnya. Halaman ini menampilkan daftar data dalam bentuk tabel yang dapat diurutkan berdasarkan tanggal, bulan, atau waktu. Pengguna juga dapat melakukan berbagai tindakan seperti melihat detail, mengedit, atau menghapus data. Selain itu, terdapat beberapa tombol aksi seperti tombol refresh dan tombol logout di bilah aplikasi, serta tombol floating action untuk menampilkan menu aksi tambahan seperti informasi aplikasi dan menambahkan data baru.
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

  final List<SaveHistory> _historyData = [];

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
  }

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
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  context.read<HistoryBloc>().add(HistoryGetAllEvent());
                },
                icon: const Icon(Icons.refresh)),
            IconButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(UserAuthLogout());
                },
                icon: const Icon(Icons.logout))
          ],
          backgroundColor: shadePinkColor,
          title: Text(
            'HI ${FirebaseAuth.instance.currentUser?.displayName != '' && FirebaseAuth.instance.currentUser?.displayName != null ? FirebaseAuth.instance.currentUser?.displayName : "User"}!',
            style: titleTextStyle.copyWith(
              fontSize: 24,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: BlocListener<HistoryActionBloc, HistoryActionState>(
          listener: (BuildContext context, HistoryActionState state) {
            if (state is HistoryActionSuccess) {
              context.read<HistoryBloc>().add(HistoryGetAllEvent());
            }
          },
          child: Padding(
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
                    BlocConsumer<HistoryBloc, HistoryState>(
                        listener: (context, state) {
                      if (state is HistoryInitial) {
                        context.read<HistoryBloc>().add(HistoryGetAllEvent());
                      }
                      if (state is HistoryLoaded) {
                        _historyData.clear();
                        setState(() {
                          _historyData.addAll(state.listHistory);
                        });
                      }
                    }, builder: (context, state) {
                      if (state is HistoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _historyData.isEmpty
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
                                            (SaveHistory sh) => extractDatetime(
                                                sh.date, "time"),
                                            columnIndex,
                                            false),
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
                                            (SaveHistory sh) => extractDatetime(
                                                sh.date, "time"),
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
                                      DataCell(Text(extractDatetime(
                                          _historyData[index].date, "date"))),
                                      DataCell(Text(_historyData[index]
                                          .pregnancyAge
                                          .toString())),
                                      DataCell(Text(extractDatetime(
                                          _historyData[index].date, "time"))),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              iconSize: 16.0,
                                              onPressed: () async {
                                                context
                                                    .read<HistoryActionBloc>()
                                                    .add(
                                                        HistoryActionDetailEvent(
                                                            _historyData[index]
                                                                .id));
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResultPage(
                                                      saveHistory: _historyData[
                                                          index], // Misalkan ini adalah data yang akan diedit
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.assignment,
                                                color: basePinkColor,
                                              ),
                                            ),
                                            IconButton(
                                              iconSize: 16.0,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        InputPage(
                                                      saveHistory: _historyData[
                                                          index], // Misalkan ini adalah data yang akan diedit
                                                      isEditing:
                                                          true, // Tandai bahwa ini adalah sesi editing, bukan membuat baru
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: basePinkColor,
                                              ),
                                            ),
                                            IconButton(
                                              iconSize: 16.0,
                                              onPressed: () async {
                                                context
                                                    .read<HistoryActionBloc>()
                                                    .add(
                                                        HistoryActionDeleteEvent(
                                                            _historyData[index]
                                                                .id));

                                                context
                                                    .read<HistoryBloc>()
                                                    .add(HistoryGetAllEvent());

                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomAlertDialog(
                                                        title:
                                                            Icons.info_outlined,
                                                        content:
                                                            "Input dengan index ke-${index + 1} telah dihapus!",
                                                      );
                                                    });
                                              },
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
                            );
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
                title: "App Info",
                iconColor: Colors.white,
                titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
                bubbleColor: basePinkColor,
                onPress: () async {
                  const snackBar = SnackBar(
                    content: Text('PINK BOOK APP by BIMA ANGGARA WIRASATYA!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: Icons.info),
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
          ],

          animation: _animation,

          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),

          iconColor: Colors.white,

          iconData: Icons.menu,
          backGroundColor: basePinkColor,
        ));
  }
}

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pink_book_app/logic/model/save_history.dart';

part 'history_action_state.dart';
part 'history_action_event.dart';

class HistoryActionBloc extends Bloc<HistoryActionEvent, HistoryActionState> {
  HistoryActionBloc() : super(HistoryActionInitial()) {
    Future<String?> getUserUID() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.uid;
      }
      return null;
    }

    on<HistoryActionAddEvent>((event, emit) async {
      emit(HistoryActionLoading());
      final uid = await getUserUID();
      if (uid != null) {
        final historiesRef = FirebaseFirestore.instance.collection("histories");
        final historyMap = event.saveInput.toMap(event.saveInput);

        // [[ additional input for history ]]
        historyMap['date'] =
            DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
        historyMap['uid'] = uid;

        print(historyMap);
        try {
          await historiesRef.add(historyMap);
          emit(HistoryActionSuccess());
        } catch (e) {
          emit(HistoryActionError(e.toString()));
        }
      }
    });

    on<HistoryActionDeleteEvent>((event, emit) async {
      final collection = FirebaseFirestore.instance.collection('histories');
      final docRef = collection.doc(event.id);
      await docRef
          .delete()
          .then((value) => print("Document deleted successfully!"))
          .catchError((error) => print("Error deleting document"));
    });

    on<HistoryActionUpdateDetailEvent>((event, emit) async {
      emit(HistoryActionLoading());
      final uid = await getUserUID();
      if (uid != null) {
        final historiesRef = FirebaseFirestore.instance.collection("histories");
        final historyMap = event.saveInput.toMap(event.saveInput);
        final docRef = historiesRef.doc(event.id);

        // [[ additional input for history ]]
        historyMap['date'] =
            DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
        historyMap['uid'] = uid;

        print(historyMap);
        try {
          await docRef.set(historyMap);
          emit(HistoryActionSuccess());
        } catch (e) {
          emit(HistoryActionError(e.toString()));
        }
      }
    });

    on<HistoryActionDetailEvent>((event, emit) async {});
  }
}

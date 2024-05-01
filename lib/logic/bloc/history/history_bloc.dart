import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pink_book_app/logic/model/save_history.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<HistoryGetAllEvent>((event, emit) async {
      final List<SaveHistory> _historyData = [];

      emit(HistoryLoading());

      try {
        final currentUid = FirebaseAuth.instance.currentUser!.uid;
        final collection = FirebaseFirestore.instance.collection('histories');
        final querySnapshot =
            await collection.where('uid', isEqualTo: currentUid).get();
        _historyData.clear();
        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          data['id'] = doc.id;
          final SaveHistory sH = SaveHistory.fromMap(data);
          print(sH.id);
          _historyData.add(sH);
        }
        emit(HistoryLoaded(_historyData));
      } catch (e) {
        print(e.toString());
        emit(HistoryLoading());
      }
    });
  }
}

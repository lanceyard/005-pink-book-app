import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

        // upload images
        final storage = FirebaseStorage.instance;
        List<String> downloadUrls = [];

        for (int i = 0; i < event.saveInput.imagePaths.length; i++) {
          final String filename =
              'images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          final storageRef = storage.ref(filename);
          final File file = File(event.saveInput.imagePaths[i]);
          final uploadTask = storageRef.putFile(file);

          final downloadUrl = await (await uploadTask).ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        }

        print("downloadUrls: $downloadUrls");

        // [[ additional input for history ]]
        historyMap['date'] =
            DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
        historyMap['uid'] = uid;
        historyMap['imagePaths'] = downloadUrls;
        try {
          await historiesRef
              .add(historyMap)
              .then((_) => emit(HistoryActionSuccess()));
        } catch (e) {
          emit(HistoryActionError(e.toString()));
        }
      }
    });

    on<HistoryActionDeleteEvent>((event, emit) async {
      final collection = FirebaseFirestore.instance.collection('histories');
      final docRef = collection.doc(event.id);
      await docRef.delete().then((value) {
        print("Document deleted successfully!");
        HistoryActionSuccess();
      }).catchError((error) => print("Error deleting document"));
    });

    on<HistoryActionUpdateDetailEvent>((event, emit) async {
      emit(HistoryActionLoading());
      final uid = await getUserUID();
      if (uid != null) {
        final historiesRef = FirebaseFirestore.instance.collection("histories");
        final historyMap = event.saveInput.toMap(event.saveInput);
        final docRef = historiesRef.doc(event.id);

        // update images
        final storage = FirebaseStorage.instance;
        List<String> downloadUrls = [];

        for (int i = 0; i < event.saveInput.imagePaths.length; i++) {
          if (event.saveInput.imagePaths[i].contains('http')) {
            downloadUrls.add(event.saveInput.imagePaths[i]);
          } else {
            final String filename =
                'images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
            final storageRef = storage.ref(filename);
            final File file = File(event.saveInput.imagePaths[i]);
            final uploadTask = storageRef.putFile(file);

            final downloadUrl = await (await uploadTask).ref.getDownloadURL();
            downloadUrls.add(downloadUrl);
          }
        }

        // [[ additional input for history ]]
        historyMap['date'] =
            DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
        historyMap['uid'] = uid;
        historyMap['imagePaths'] = downloadUrls;
        historyMap['id'] = event.id;

        print("RESULT IS $historyMap");
        try {
          await docRef
              .set(historyMap)
              .then((value) => emit(HistoryActionSuccess()));
        } catch (e) {
          emit(HistoryActionError(e.toString()));
        }
      }
    });

    on<HistoryActionDetailEvent>((event, emit) async {});
  }
}

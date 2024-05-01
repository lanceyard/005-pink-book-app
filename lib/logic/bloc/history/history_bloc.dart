import 'package:bloc/bloc.dart';
import 'package:pink_book_app/logic/model/save_history.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {

  }
}

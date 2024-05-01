part of 'history_bloc.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoaded extends HistoryState {
  List<SaveHistory> listHistory;
  HistoryLoaded(this.listHistory);
}

class HistoryError extends HistoryState {
  String msg;
  HistoryError(this.msg);
}

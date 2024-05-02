part of 'history_action_bloc.dart';

abstract class HistoryActionState {}

class HistoryActionInitial extends HistoryActionState {}

class HistoryActionLoading extends HistoryActionState {}

class HistoryActionLoaded extends HistoryActionState {
  SaveHistory saveHistory;
  HistoryActionLoaded(this.saveHistory);
}

class HistoryActionSuccess extends HistoryActionState {}

class HistoryActionError extends HistoryActionState {
  String msg;
  HistoryActionError(this.msg);
}

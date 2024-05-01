part of 'history_action_bloc.dart';

abstract class HistoryActionEvent {}

class HistoryActionAddEvent extends HistoryActionEvent {
  SaveHistory saveInput;
  HistoryActionAddEvent(this.saveInput);
}

class HistoryActionDeleteEvent extends HistoryActionEvent {
  String id;
  HistoryActionDeleteEvent(this.id);
}

class HistoryActionDetailEvent extends HistoryActionEvent {
  String id;
  HistoryActionDetailEvent(this.id);
}

class HistoryActionUpdateDetailEvent extends HistoryActionEvent {
  String id;
  SaveHistory saveInput;
  HistoryActionUpdateDetailEvent(this.id, this.saveInput);
}

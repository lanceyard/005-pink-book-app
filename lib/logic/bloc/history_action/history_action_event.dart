part of 'history_action_bloc.dart';

abstract class HistoryActionEvent {}

class HistoryActionAddEvent extends HistoryActionEvent {
  SaveHistory saveInput;
	HistoryActionAddEvent(this.saveInput);
}


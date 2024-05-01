part of 'history_bloc.dart';

abstract class HistoryEvent {}

// class HistorySaveEvent extends HistoryEvent {
//   SaveHistory saveInput;
//   HistorySaveEvent(this.saveInput);
// }
//
class HistoryUpdateEvent extends HistoryEvent {
  SaveHistory saveInput;
  HistoryUpdateEvent(this.saveInput);
}

class HistoryRemoveEvent extends HistoryEvent {}

class HistoryGetAllEvent extends HistoryEvent {}

class HistoryGetSpecificEvent extends HistoryEvent {}

part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class GetBookings extends HomeEvent {
  @override
  List<Object> get props => [];
}

class CancelPressed extends HomeEvent {
  final int index;

  CancelPressed(this.index);

  @override
  List<Object> get props => [index];
}

class GetBalance extends HomeEvent {
  GetBalance();

  @override
  List<Object> get props => [];
}

class FilterChanged extends HomeEvent {
  final TicketStatusFilter filter;

  FilterChanged(this.filter);

  @override
  List<Object> get props => [filter];
}

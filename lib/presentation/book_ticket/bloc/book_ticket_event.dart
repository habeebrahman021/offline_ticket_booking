part of 'book_ticket_bloc.dart';

abstract class BookTicketEvent extends Equatable {
  const BookTicketEvent();
}

class PassengerNameChanged extends BookTicketEvent {
  const PassengerNameChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class DistanceChanged extends BookTicketEvent {
  const DistanceChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class JourneyDateChanged extends BookTicketEvent {
  const JourneyDateChanged(this.value);

  final DateTime value;

  @override
  List<Object> get props => [value];
}

class GetTicketClasses extends BookTicketEvent {
  const GetTicketClasses();

  @override
  List<Object?> get props => [];
}

class TicketClassChanged extends BookTicketEvent {
  const TicketClassChanged(this.value);

  final TicketClass value;

  @override
  List<Object> get props => [value];
}

class CalculateAmount extends BookTicketEvent {
  const CalculateAmount();

  @override
  List<Object?> get props => [];
}

class BookTicketPressed extends BookTicketEvent {
  const BookTicketPressed();

  @override
  List<Object?> get props => [];
}

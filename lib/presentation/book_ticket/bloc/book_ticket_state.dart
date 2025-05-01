part of 'book_ticket_bloc.dart';

class BookTicketState extends Equatable {
  const BookTicketState({
    this.passengerName = '',
    this.distance = '',
    this.journeyDate,
    this.ticketClass,
    this.ticketClassList = const [],
    this.amount = 0,
    this.saveStatus = Status.initial,
  });

  final String passengerName;
  final String distance;
  final DateTime? journeyDate;
  final TicketClass? ticketClass;
  final double amount;

  final List<TicketClass> ticketClassList;

  final Status saveStatus;

  @override
  List<Object?> get props => [
    passengerName,
    distance,
    journeyDate,
    ticketClass,
    ticketClassList,
    amount,
    saveStatus,
  ];

  BookTicketState copyWith({
    String? passengerName,
    String? distance,
    DateTime? journeyDate,
    TicketClass? ticketClass,
    double? amount,
    List<TicketClass>? ticketClassList,
    Status? saveStatus,
  }) {
    return BookTicketState(
      passengerName: passengerName ?? this.passengerName,
      distance: distance ?? this.distance,
      journeyDate: journeyDate ?? this.journeyDate,
      ticketClass: ticketClass ?? this.ticketClass,
      amount: amount ?? this.amount,
      ticketClassList: ticketClassList ?? this.ticketClassList,
      saveStatus: saveStatus ?? this.saveStatus,
    );
  }
}

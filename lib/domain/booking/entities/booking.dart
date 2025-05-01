import 'package:equatable/equatable.dart';
import 'package:offline_ticket_booking/core/utils/enums/ticket_status.dart';

class Booking extends Equatable {
  final int? id;
  final String passengerName;
  final DateTime bookingDate;
  final DateTime journeyDate;
  final double distance;
  final double amount;
  final int classId;
  final String className;
  final TicketStatus? status;

  const Booking({
    this.id,
    required this.passengerName,
    required this.bookingDate,
    required this.journeyDate,
    required this.distance,
    required this.amount,
    required this.classId,
    required this.className,
    this.status,
  });

  @override
  List<Object?> get props => [
    id,
    passengerName,
    bookingDate,
    journeyDate,
    distance,
    amount,
    classId,
    className,
    status,
  ];
}

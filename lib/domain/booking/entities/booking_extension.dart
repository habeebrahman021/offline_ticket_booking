import 'package:offline_ticket_booking/core/utils/enums/ticket_status.dart';
import 'package:offline_ticket_booking/data/booking/dto/booking_dto.dart';
import 'package:offline_ticket_booking/domain/booking/entities/booking.dart';

extension BookingDtoExtension on BookingDto {
  Booking toEntity() {
    final journey = DateTime.fromMillisecondsSinceEpoch(journeyDate ?? 0);
    return Booking(
      id: id ?? -1,
      passengerName: passengerName ?? '',
      bookingDate: DateTime.fromMillisecondsSinceEpoch(bookingDate ?? 0),
      journeyDate: journey,
      distance: distance ?? 0,
      amount: amount ?? 0,
      classId: classId ?? -1,
      className: className ?? '',
      status: _getTicketStatus(status ?? 1, journey),
    );
  }

  TicketStatus _getTicketStatus(int status, DateTime journeyDate) {
    if (status == 0) return TicketStatus.cancelled;

    final now = DateTime.now();
    if (now.isBefore(journeyDate.add(Duration(hours: 24)))) {
      return TicketStatus.upcoming;
    } else {
      return TicketStatus.completed;
    }
  }
}

extension BookingDtoListExtension on List<BookingDto> {
  List<Booking> toEntityList() => map((dto) => dto.toEntity()).toList();
}

extension BookingExtension on Booking {
  BookingDto toDto() => BookingDto(
    passengerName: passengerName,
    bookingDate: bookingDate.millisecondsSinceEpoch,
    journeyDate: journeyDate.millisecondsSinceEpoch,
    distance: distance,
    amount: amount,
    classId: classId,
    className: className,
  );
}

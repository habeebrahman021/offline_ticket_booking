import 'package:offline_ticket_booking/domain/booking/entities/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookings();

  Future<void> createBooking({required Booking booking});

  Future<void> cancelBooking({required int id});
}

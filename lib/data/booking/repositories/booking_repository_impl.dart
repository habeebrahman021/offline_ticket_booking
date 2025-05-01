import 'package:offline_ticket_booking/data/booking/datasources/local/booking_data_source.dart';
import 'package:offline_ticket_booking/domain/booking/entities/booking.dart';
import 'package:offline_ticket_booking/domain/booking/entities/booking_extension.dart';
import 'package:offline_ticket_booking/domain/booking/repositories/booking_repository.dart';

class BookingRepositoryImpl extends BookingRepository {
  final BookingsDataSource bookingsDataSource;

  BookingRepositoryImpl({required this.bookingsDataSource});

  @override
  Future<List<Booking>> getBookings() async {
    final result = await bookingsDataSource.getBookings();
    return result.toEntityList();
  }

  @override
  Future<void> createBooking({required Booking booking}) {
    return bookingsDataSource.createBooking(booking.toDto());
  }

  @override
  Future<void> cancelBooking({required int id}) async {
    final result = await bookingsDataSource.cancelBooking(id);
    if (result == 0) {
      throw Exception('Booking with id $id not found');
    }
  }
}

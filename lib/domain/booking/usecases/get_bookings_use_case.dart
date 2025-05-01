import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/domain/booking/entities/booking.dart';
import 'package:offline_ticket_booking/domain/booking/repositories/booking_repository.dart';

class GetBookingsUseCase
    extends UseCase<List<Booking>, GetBookingsUseCaseParams> {
  final BookingRepository bookingRepository;

  GetBookingsUseCase({required this.bookingRepository});

  @override
  Future<List<Booking>> execute(GetBookingsUseCaseParams params) async {
    return await bookingRepository.getBookings();
  }
}

class GetBookingsUseCaseParams {}

import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/domain/booking/entities/booking.dart';
import 'package:offline_ticket_booking/domain/booking/entities/ticket_class.dart';
import 'package:offline_ticket_booking/domain/booking/repositories/booking_repository.dart';
import 'package:offline_ticket_booking/domain/wallet/repositories/wallet_repository.dart';

class CreateBookingUseCase extends UseCase<void, CreateBookingUseCaseParams> {
  final BookingRepository repository;
  final WalletRepository walletRepository;

  CreateBookingUseCase({
    required this.repository,
    required this.walletRepository,
  });

  @override
  Future<void> execute(CreateBookingUseCaseParams params) async {
    final balance = await walletRepository.getBalance(id: 1);
    if (balance < params.amount) {
      throw Exception('Insufficient wallet balance');
    }

    final bookingDate = DateTime.now();
    final distance = double.tryParse(params.distance) ?? 0;

    await repository.createBooking(
      booking: Booking(
        passengerName: params.passengerName,
        bookingDate: bookingDate,
        journeyDate: params.journeyDate,
        distance: distance,
        amount: params.amount,
        classId: params.ticketClass.id,
        className: params.ticketClass.name,
      ),
    );

    await walletRepository.withdraw(id: 1, amount: params.amount);
  }
}

class CreateBookingUseCaseParams {
  final String passengerName;
  final String distance;
  final double amount;
  final DateTime journeyDate;
  final TicketClass ticketClass;

  CreateBookingUseCaseParams({
    required this.passengerName,
    required this.distance,
    required this.amount,
    required this.journeyDate,
    required this.ticketClass,
  });
}

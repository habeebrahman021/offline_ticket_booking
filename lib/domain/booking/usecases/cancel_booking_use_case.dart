import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/domain/booking/repositories/booking_repository.dart';
import 'package:offline_ticket_booking/domain/wallet/repositories/wallet_repository.dart';

class CancelBookingUseCase extends UseCase<void, CancelBookingUseCaseParams> {
  final BookingRepository repository;
  final WalletRepository walletRepository;

  CancelBookingUseCase({
    required this.repository,
    required this.walletRepository,
  });

  @override
  Future<void> execute(CancelBookingUseCaseParams params) async {
    await repository.cancelBooking(id: params.id);
    await walletRepository.deposit(id: 1, amount: params.refundAmount);
  }
}

class CancelBookingUseCaseParams {
  final int id;
  final double refundAmount;

  CancelBookingUseCaseParams({required this.id, required this.refundAmount});
}

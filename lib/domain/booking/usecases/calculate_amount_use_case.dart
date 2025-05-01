import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/domain/booking/entities/ticket_class.dart';

class CalculateAmountUseCase
    extends UseCase<double, CalculateAmountUseCaseParams> {
  @override
  Future<double> execute(CalculateAmountUseCaseParams params) {
    final distance = double.tryParse(params.distance) ?? 0;
    final minAmount = params.ticketClass.minAmount;
    final ticketClassAmount = params.ticketClass.amount;

    final amount =
        (distance > 1)
            ? minAmount + (distance - 1) * ticketClassAmount
            : minAmount;

    return Future.value(amount);
  }
}

class CalculateAmountUseCaseParams {
  final String distance;
  final TicketClass ticketClass;

  CalculateAmountUseCaseParams({
    required this.distance,
    required this.ticketClass,
  });
}

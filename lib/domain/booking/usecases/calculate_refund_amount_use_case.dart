import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/domain/booking/entities/booking.dart';

class CalculateRefundAmountUseCase
    extends UseCase<double, CalculateRefundAmountParams> {
  @override
  Future<double> execute(CalculateRefundAmountParams params) async {
    final journeyDate = params.booking.journeyDate;

    final now = DateTime.now();
    final hoursBeforeJourney = journeyDate.difference(now).inHours;

    int refundPercentage = 0;

    if (hoursBeforeJourney >= 168) {
      switch (params.booking.classId) {
        case 1:
          refundPercentage = 100;
          break;
        case 2:
          refundPercentage = 95;
          break;
        case 3:
          refundPercentage = 90;
          break;
        case 4:
          refundPercentage = 85;
          break;
      }
    } else if (hoursBeforeJourney >= 48) {
      switch (params.booking.classId) {
        case 1:
          refundPercentage = 80;
          break;
        case 2:
          refundPercentage = 75;
          break;
        case 3:
          refundPercentage = 70;
          break;
        case 4:
          refundPercentage = 65;
          break;
      }
    } else if (hoursBeforeJourney >= 24) {
      switch (params.booking.classId) {
        case 1:
          refundPercentage = 50;
          break;
        case 2:
          refundPercentage = 45;
          break;
        case 3:
          refundPercentage = 40;
          break;
        case 4:
          refundPercentage = 35;
          break;
      }
    } else if (hoursBeforeJourney < 2) {
      refundPercentage = 0;
    } else {
      refundPercentage = 0;
    }

    return (params.booking.amount * refundPercentage) / 100;
  }
}

class CalculateRefundAmountParams {
  final Booking booking;

  CalculateRefundAmountParams({required this.booking});
}

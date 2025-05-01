import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/core/utils/enums/ticket_status.dart';
import 'package:offline_ticket_booking/core/utils/enums/ticket_status_filter.dart';
import 'package:offline_ticket_booking/domain/booking/entities/booking.dart';

class FilterBookingsUseCase
    extends UseCase<List<Booking>, FilterBookingsUseCaseParams> {
  @override
  Future<List<Booking>> execute(FilterBookingsUseCaseParams params) async {
    switch (params.filter) {
      case TicketStatusFilter.all:
        return params.bookings;
      case TicketStatusFilter.upcoming:
        return params.bookings
            .where((booking) => booking.status?.isUpcoming ?? false)
            .toList();
      case TicketStatusFilter.completed:
        return params.bookings
            .where((booking) => booking.status?.isCompleted ?? false)
            .toList();
      case TicketStatusFilter.cancelled:
        return params.bookings
            .where((booking) => booking.status?.isCancelled ?? false)
            .toList();
    }
  }
}

class FilterBookingsUseCaseParams {
  final List<Booking> bookings;
  final TicketStatusFilter filter;

  FilterBookingsUseCaseParams({required this.bookings, required this.filter});
}

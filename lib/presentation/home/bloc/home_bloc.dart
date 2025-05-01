import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/core/utils/enums/status.dart';
import 'package:offline_ticket_booking/core/utils/enums/ticket_status_filter.dart';
import 'package:offline_ticket_booking/core/utils/utils.dart';
import 'package:offline_ticket_booking/domain/booking/entities/booking.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/calculate_refund_amount_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/cancel_booking_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/filter_bookings_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/get_bookings_use_case.dart';
import 'package:offline_ticket_booking/domain/notification/notification_use_case.dart';
import 'package:offline_ticket_booking/domain/wallet/usecases/get_wallet_balance_use_case.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.getBookingsUseCase,
    required this.cancelBookingUseCase,
    required this.getWalletBalanceUseCase,
    required this.calculateRefundAmountUseCase,
    required this.showNotificationUseCase,
    required this.filterBookingsUseCase,
  }) : super(HomeState()) {
    on<HomeEvent>((event, emit) {});
    on<GetBookings>(_onGetBookings);
    on<CancelPressed>(_onCancelPressed);
    on<GetBalance>(_onGetBalance);
    on<FilterChanged>(_onFilterChanged);
  }

  final GetBookingsUseCase getBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final GetWalletBalanceUseCase getWalletBalanceUseCase;
  final CalculateRefundAmountUseCase calculateRefundAmountUseCase;
  final ShowNotificationUseCase showNotificationUseCase;
  final FilterBookingsUseCase filterBookingsUseCase;

  Future<void> _onGetBookings(
    GetBookings event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(bookingsStatus: Status.inProgress));
    final result = await getBookingsUseCase(GetBookingsUseCaseParams());

    switch (result) {
      case Success(:final value):
        emit(state.copyWith(bookings: value, bookingsStatus: Status.success));
        add(FilterChanged(state.filter));
      case Failure():
        emit(state.copyWith(bookingsStatus: Status.failure));
    }
  }

  Future<void> _onCancelPressed(
    CancelPressed event,
    Emitter<HomeState> emit,
  ) async {
    final id = state.bookings[event.index].id ?? -1;
    if (id == -1) {
      Utils.showToast('Failed to cancel booking');
      return;
    }

    final refund = await calculateRefundAmountUseCase(
      CalculateRefundAmountParams(booking: state.bookings[event.index]),
    );

    switch (refund) {
      case Success(:final value):
        final result = await cancelBookingUseCase(
          CancelBookingUseCaseParams(id: id, refundAmount: value),
        );
        switch (result) {
          case Success():
            Utils.showToast(
              'Booking cancelled successfully. A refund of ${value.toStringAsFixed(2)} has been initiated.',
            );
            add(GetBookings());
            add(GetBalance());
            await showNotificationUseCase(
              ShowNotificationUseCaseParams(
                title: '#$id Ticket Cancelled',
                body:
                    'Ticket Cancelled Successfully. '
                    'A refund of ${value.toStringAsFixed(2)}'
                    ' has been initiated.',
              ),
            );
          case Failure():
            Utils.showToast('Failed to cancel booking');
            break;
        }
      case Failure<double>():
        Utils.showToast('Failed to cancel booking');
        break;
    }
  }

  Future<void> _onGetBalance(GetBalance event, Emitter<HomeState> emit) async {
    final result = await getWalletBalanceUseCase(
      GetWalletBalanceUseCaseParams(id: 1),
    );

    switch (result) {
      case Success(:final value):
        emit(state.copyWith(balance: value));
      case Failure():
        break;
    }
  }

  Future<void> _onFilterChanged(
    FilterChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(filter: event.filter));
    final result = await filterBookingsUseCase(
      FilterBookingsUseCaseParams(
        bookings: state.bookings,
        filter: event.filter,
      ),
    );

    switch (result) {
      case Success(:final value):
        emit(state.copyWith(filteredBookings: value));
      case Failure<List<Booking>>():
        break;
    }
  }
}

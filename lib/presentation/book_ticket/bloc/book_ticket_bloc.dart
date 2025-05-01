import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/core/utils/enums/status.dart';
import 'package:offline_ticket_booking/core/utils/utils.dart';
import 'package:offline_ticket_booking/domain/booking/entities/ticket_class.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/calculate_amount_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/create_booking_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/get_ticket_classes_use_case.dart';
import 'package:offline_ticket_booking/domain/notification/notification_use_case.dart';

part 'book_ticket_event.dart';

part 'book_ticket_state.dart';

class BookTicketBloc extends Bloc<BookTicketEvent, BookTicketState> {
  BookTicketBloc({
    required this.getTicketClassesUseCase,
    required this.calculateAmountUseCase,
    required this.createBookingUseCase,
    required this.showNotificationUseCase,
    BookTicketState? initialState,
  }) : super(BookTicketState()) {
    on<BookTicketEvent>((event, emit) {});

    on<PassengerNameChanged>(_onPassengerNameChanged);
    on<DistanceChanged>(_onDistanceChanged);
    on<JourneyDateChanged>(_onJourneyDateChanged);
    on<TicketClassChanged>(_onTicketClassChanged);
    on<GetTicketClasses>(_onGetTicketClasses);
    on<CalculateAmount>(_onCalculateAmount);
    on<BookTicketPressed>(_onBookTicketPressed);
  }

  final GetTicketClassesUseCase getTicketClassesUseCase;
  final CalculateAmountUseCase calculateAmountUseCase;
  final CreateBookingUseCase createBookingUseCase;
  final ShowNotificationUseCase showNotificationUseCase;

  FutureOr<void> _onPassengerNameChanged(
    PassengerNameChanged event,
    Emitter<BookTicketState> emit,
  ) {
    emit(state.copyWith(passengerName: event.value));
  }

  FutureOr<void> _onDistanceChanged(
    DistanceChanged event,
    Emitter<BookTicketState> emit,
  ) {
    emit(state.copyWith(distance: event.value));
    add(CalculateAmount());
  }

  FutureOr<void> _onJourneyDateChanged(
    JourneyDateChanged event,
    Emitter<BookTicketState> emit,
  ) {
    emit(state.copyWith(journeyDate: event.value));
    add(CalculateAmount());
  }

  Future<void> _onGetTicketClasses(
    GetTicketClasses event,
    Emitter<BookTicketState> emit,
  ) async {
    final result = await getTicketClassesUseCase(NoParams());
    switch (result) {
      case Success(:final value):
        emit(state.copyWith(ticketClassList: value));
      case Failure():
        break;
    }
  }

  FutureOr<void> _onTicketClassChanged(
    TicketClassChanged event,
    Emitter<BookTicketState> emit,
  ) {
    emit(state.copyWith(ticketClass: event.value));
    add(CalculateAmount());
  }

  Future<void> _onCalculateAmount(
    CalculateAmount event,
    Emitter<BookTicketState> emit,
  ) async {
    if (state.ticketClass != null) {
      final result = await calculateAmountUseCase(
        CalculateAmountUseCaseParams(
          ticketClass: state.ticketClass!,
          distance: state.distance,
        ),
      );
      switch (result) {
        case Success(:final value):
          emit(state.copyWith(amount: value));
        case Failure():
          break;
      }
    }
  }

  Future<void> _onBookTicketPressed(
    BookTicketPressed event,
    Emitter<BookTicketState> emit,
  ) async {
    if (state.ticketClass == null || state.journeyDate == null) {
      return;
    }

    emit(state.copyWith(saveStatus: Status.inProgress));

    final result = await createBookingUseCase(
      CreateBookingUseCaseParams(
        passengerName: state.passengerName,
        ticketClass: state.ticketClass!,
        distance: state.distance,
        journeyDate: state.journeyDate!,
        amount: state.amount,
      ),
    );

    switch (result) {
      case Success():
        await showNotificationUseCase(
          ShowNotificationUseCaseParams(
            title: 'Ticket Booked',
            body: 'Ticket booked successfully. Please check your bookings.',
          ),
        );
        emit(state.copyWith(saveStatus: Status.success));
      case Failure(:final exception):
        Utils.showToast(exception.toString());
        emit(state.copyWith(saveStatus: Status.failure));
    }
  }
}

part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.bookingsStatus = Status.initial,
    this.bookings = const [],
    this.filteredBookings = const [],
    this.balance = 0.0,
    this.filter = TicketStatusFilter.all,
  });

  final Status bookingsStatus;
  final List<Booking> bookings;
  final List<Booking> filteredBookings;
  final double balance;
  final TicketStatusFilter filter;

  @override
  List<Object> get props => [
    bookingsStatus,
    bookings,
    balance,
    filter,
    filteredBookings,
  ];

  HomeState copyWith({
    Status? bookingsStatus,
    List<Booking>? bookings,
    List<Booking>? filteredBookings,
    double? balance,
    TicketStatusFilter? filter,
  }) {
    return HomeState(
      bookingsStatus: bookingsStatus ?? this.bookingsStatus,
      bookings: bookings ?? this.bookings,
      filteredBookings: filteredBookings ?? this.filteredBookings,
      balance: balance ?? this.balance,
      filter: filter ?? this.filter,
    );
  }
}

part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.bookingsStatus = Status.initial,
    this.bookings = const [],
    this.balance = 0.0,
  });

  final Status bookingsStatus;
  final List<Booking> bookings;
  final double balance;

  @override
  List<Object> get props => [bookingsStatus, bookings, balance];

  HomeState copyWith({
    Status? bookingsStatus,
    List<Booking>? bookings,
    double? balance,
  }) {
    return HomeState(
      bookingsStatus: bookingsStatus ?? this.bookingsStatus,
      bookings: bookings ?? this.bookings,
      balance: balance ?? this.balance,
    );
  }
}

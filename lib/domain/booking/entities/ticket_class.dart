import 'package:equatable/equatable.dart';

class TicketClass extends Equatable {
  final int id;
  final String name;
  final double amount;
  final double minAmount;

  const TicketClass({
    required this.id,
    required this.name,
    required this.amount,
    required this.minAmount,
  });

  @override
  List<Object?> get props => [id, name, amount, minAmount];
}

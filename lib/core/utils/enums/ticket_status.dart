import 'package:flutter/material.dart';

enum TicketStatus { upcoming, completed, cancelled }

extension TicketStatusExtension on TicketStatus {
  bool get isCompleted => this == TicketStatus.completed;

  bool get isCancelled => this == TicketStatus.cancelled;

  bool get isUpcoming => this == TicketStatus.upcoming;

  String get name {
    switch (this) {
      case TicketStatus.upcoming:
        return 'Upcoming';
      case TicketStatus.completed:
        return 'Completed';
      case TicketStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.upcoming:
        return Colors.blue;
      case TicketStatus.completed:
        return Colors.green;
      case TicketStatus.cancelled:
        return Colors.red;
    }
  }
}

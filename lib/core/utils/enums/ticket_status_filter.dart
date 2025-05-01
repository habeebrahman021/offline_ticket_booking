enum TicketStatusFilter { all, upcoming, completed, cancelled }

extension TicketStatusFilterExtension on TicketStatusFilter {
  bool get isCompleted => this == TicketStatusFilter.completed;

  bool get isCancelled => this == TicketStatusFilter.cancelled;

  bool get isUpcoming => this == TicketStatusFilter.upcoming;

  bool get isAll => this == TicketStatusFilter.all;

  String get name {
    switch (this) {
      case TicketStatusFilter.upcoming:
        return 'Upcoming';
      case TicketStatusFilter.completed:
        return 'Completed';
      case TicketStatusFilter.cancelled:
        return 'Cancelled';
      case TicketStatusFilter.all:
        return 'All';
    }
  }
}

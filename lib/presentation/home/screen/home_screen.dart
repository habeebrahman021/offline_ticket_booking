import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:offline_ticket_booking/core/di/injector.dart';
import 'package:offline_ticket_booking/core/router/app_router.dart';
import 'package:offline_ticket_booking/core/utils/enums/ticket_status.dart';
import 'package:offline_ticket_booking/core/utils/extensions/datetime_extension.dart';
import 'package:offline_ticket_booking/domain/booking/entities/booking.dart';
import 'package:offline_ticket_booking/presentation/home/bloc/home_bloc.dart';
import 'package:offline_ticket_booking/presentation/home/widgets/ticket_status_filter_bottom_sheet.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              injector<HomeBloc>()
                ..add(GetBookings())
                ..add(GetBalance()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const _HomeBody(),
      floatingActionButton: const _BookTicketFAB(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            BalanceCard(balance: state.balance),
            const Gap(16),
            const BookingsHeader(),
            Expanded(
              child:
                  state.filteredBookings.isEmpty
                      ? const NoBookingsPlaceholder()
                      : BookingsList(bookings: state.filteredBookings),
            ),
          ],
        );
      },
    );
  }
}

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CardContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Balance', style: TextStyle(fontSize: 16)),
            const Gap(8),
            Text(
              '₹${balance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const Gap(8),
            Text('As On ${DateTime.now().toStringFormatted('MMM dd, yyyy')}'),
          ],
        ),
      ),
    );
  }
}

class BookingsHeader extends StatelessWidget {
  const BookingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Bookings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _showFilterBottomSheet(context),
            icon: const Icon(Icons.filter_alt_outlined),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final currentFilter = context.read<HomeBloc>().state.filter;
    showTicketStatusFilterBottomSheet(
      context: context,
      selected: currentFilter,
      onSelected: (newFilter) {
        context.read<HomeBloc>().add(FilterChanged(newFilter));
      },
    );
  }
}

class BookingsList extends StatelessWidget {
  final List<Booking> bookings;

  const BookingsList({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: bookings.length,
      itemBuilder:
          (context, index) =>
              BookingListItem(booking: bookings[index], index: index),
      separatorBuilder: (context, index) => const Gap(16),
    );
  }
}

class BookingListItem extends StatelessWidget {
  final Booking booking;
  final int index;

  const BookingListItem({
    super.key,
    required this.booking,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: booking.status?.isUpcoming ?? false,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.cancel,
            label: 'Cancel',
            borderRadius: BorderRadius.circular(8),
            onPressed:
                (_) => context.read<HomeBloc>().add(CancelPressed(index)),
          ),
        ],
      ),
      child: CardContainer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PassengerInfo(
              name: booking.passengerName,
              className: booking.className,
            ),
            const Spacer(),
            BookingDetails(amount: booking.amount, status: booking.status),
          ],
        ),
      ),
    );
  }
}

class PassengerInfo extends StatelessWidget {
  final String name;
  final String className;

  const PassengerInfo({super.key, required this.name, required this.className});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Gap(8),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Class: '),
              TextSpan(
                text: className,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookingDetails extends StatelessWidget {
  final double amount;
  final TicketStatus? status;

  const BookingDetails({super.key, required this.amount, this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "₹${amount.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const Gap(8),
        if (status != null) StatusIndicator(status: status!),
      ],
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final TicketStatus status;

  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class NoBookingsPlaceholder extends StatelessWidget {
  const NoBookingsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Bookings. Press + to book new ticket.'),
    );
  }
}

class _BookTicketFAB extends StatelessWidget {
  const _BookTicketFAB();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final router = context.router;
        final bloc = context.read<HomeBloc>();
        final bool? result = await router.push<bool>(BookTicketRoute());
        if (result == true) {
          bloc.add(GetBookings());
          bloc.add(GetBalance());
        }
      },
      child: const Icon(Icons.add),
    );
  }
}

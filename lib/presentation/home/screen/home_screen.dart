import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:offline_ticket_booking/core/di/injector.dart';
import 'package:offline_ticket_booking/core/router/app_router.dart';
import 'package:offline_ticket_booking/core/utils/enums/ticket_status.dart';
import 'package:offline_ticket_booking/core/utils/extensions/datetime_extension.dart';
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
            Gap(16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Balance', style: TextStyle(fontSize: 16)),
                    Gap(8),
                    Text(
                      '₹${state.balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gap(8),
                    Text(
                      'As On '
                      '${DateTime.now().toStringFormatted('MMM dd, yyyy')}',
                    ),
                  ],
                ),
              ),
            ),
            Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Bookings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      showTicketStatusFilterBottomSheet(
                        context: context,
                        selected: state.filter,
                        onSelected: (newFilter) {
                          context.read<HomeBloc>().add(
                            FilterChanged(newFilter),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.filter_alt_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  state.filteredBookings.isEmpty
                      ? Center(
                        child: Text('No Bookings. Press + to book new ticket.'),
                      )
                      : ListView.separated(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 120),
                        itemCount: state.filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = state.filteredBookings[index];
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
                                  onPressed: (BuildContext context) {
                                    context.read<HomeBloc>().add(
                                      CancelPressed(index),
                                    );
                                  },
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        booking.passengerName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Gap(8),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(text: 'Class: '),
                                            TextSpan(
                                              text: booking.className,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "₹${booking.amount.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Gap(8),
                                      if (booking.status != null)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: booking.status?.color,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            booking.status!.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Gap(16),
                      ),
            ),
          ],
        );
      },
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

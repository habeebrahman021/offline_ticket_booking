import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:gap/gap.dart';
import 'package:offline_ticket_booking/core/di/injector.dart';
import 'package:offline_ticket_booking/core/utils/enums/status.dart';
import 'package:offline_ticket_booking/core/utils/extensions/datetime_extension.dart';
import 'package:offline_ticket_booking/core/utils/utils.dart';
import 'package:offline_ticket_booking/domain/booking/entities/ticket_class.dart';
import 'package:offline_ticket_booking/presentation/book_ticket/bloc/book_ticket_bloc.dart';

@RoutePage()
class BookTicketScreen extends StatefulWidget {
  const BookTicketScreen({super.key});

  @override
  State<BookTicketScreen> createState() => _BookTicketScreenState();
}

class _BookTicketScreenState extends State<BookTicketScreen> {
  late TextEditingController _nameController;
  late TextEditingController _distanceController;
  late TextEditingController _dateController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _distanceController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<BookTicketBloc>()..add(GetTicketClasses()),
      child: BlocListener<BookTicketBloc, BookTicketState>(
        listener: (context, state) {
          if (state.saveStatus.isSuccess) {
            Utils.showToast('Ticket booked successfully');
            // Navigator.pop(context, true);
            // context.router.pop(true);
           context. router.maybePop<bool>(true);
          }
          if (state.passengerName != _nameController.text) {
            _nameController.text = state.passengerName;
          }
          if (state.distance != _distanceController.text) {
            _distanceController.text = state.distance;
          }
          if (state.journeyDate?.toStringFormatted('dd-MM-yyyy HH:mm') !=
              _dateController.text) {
            _dateController.text =
                state.journeyDate?.toStringFormatted('dd-MM-yyyy HH:mm') ?? '';
          }
        },
        child: BlocBuilder<BookTicketBloc, BookTicketState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: const Text('Book Ticket')),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Passenger Name',
                            border: OutlineInputBorder(),
                            hintText: 'Enter Passenger Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter passenger name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            context.read<BookTicketBloc>().add(
                              PassengerNameChanged(value),
                            );
                          },
                        ),
                        Gap(16),
                    
                        TextFormField(
                          controller: _distanceController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Distance',
                            border: OutlineInputBorder(),
                            hintText: 'Enter Distance (Km)',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter distance';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            context.read<BookTicketBloc>().add(
                              DistanceChanged(value),
                            );
                          },
                        ),
                        Gap(16),
                        TextFormField(
                          controller: _dateController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Journey Date & Time',
                            border: OutlineInputBorder(),
                            hintText: 'Select Date & Time',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select journey date & time';
                            }
                            return null;
                          },
                          onTap: () {
                            openDatePicker(context);
                          },
                        ),
                        Gap(16),
                        FormField<TicketClass>(
                          initialValue: state.ticketClass,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a ticket class';
                            }
                            return null;
                          },
                          builder: (FormFieldState<TicketClass> field) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownMenu<TicketClass>(
                                  width: double.infinity,
                                  initialSelection: field.value,
                                  requestFocusOnTap: true,
                                  label: const Text('Ticket Class'),
                                  onSelected: (TicketClass? value) {
                                    if (value == null) return;
                                    field.didChange(
                                      value,
                                    ); // update FormField state
                                    context.read<BookTicketBloc>().add(
                                      TicketClassChanged(value),
                                    );
                                  },
                                  dropdownMenuEntries:
                                      state.ticketClassList.map((e) {
                                        return DropdownMenuEntry<TicketClass>(
                                          value: e,
                                          label: e.name,
                                        );
                                      }).toList(),
                                ),
                                if (field.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      field.errorText!,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        Gap(24),
                        Center(
                          child: Text(
                            'Amount: ${state.amount}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    
                        Gap(24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Set your desired color here
                              foregroundColor: Colors.white, // Text/icon color
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<BookTicketBloc>().add(
                                  BookTicketPressed(),
                                );
                              }
                            },
                            child: Text('Book Ticket'),
                          ),
                        ),
                    
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void openDatePicker(BuildContext context) {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 30)),
      onChanged: (date) {},
      onConfirm: (date) {
        context.read<BookTicketBloc>().add(JourneyDateChanged(date));
      },
      currentTime: DateTime.now(),
    );
  }
}

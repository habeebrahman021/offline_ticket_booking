import 'package:flutter/material.dart';
import 'package:offline_ticket_booking/core/utils/enums/ticket_status_filter.dart';

Future<void> showTicketStatusFilterBottomSheet({
  required BuildContext context,
  required TicketStatusFilter selected,
  required ValueChanged<TicketStatusFilter> onSelected,
}) async {
  return await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) {
      TicketStatusFilter currentSelection = selected;

      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Filter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...TicketStatusFilter.values.map((filter) {
                return ListTile(
                  title: Text(filter.name),
                  trailing: Radio<TicketStatusFilter>(
                    value: filter,
                    groupValue: currentSelection,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          currentSelection = value;
                        });
                        onSelected(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  onTap: () {
                    setState(() {
                      currentSelection = filter;
                    });
                    onSelected(filter);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          );
        },
      );
    },
  );
}

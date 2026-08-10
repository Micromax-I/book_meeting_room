import 'package:flutter/material.dart';

import '../../../core/widget/app_input_decoration.dart';

class BookingRoomDropdown extends StatelessWidget {
  final List<dynamic> rooms;
  final int? selectedRoomId;
  final ValueChanged<int?> onChanged;

  const BookingRoomDropdown({
    super.key,
    required this.rooms,
    required this.selectedRoomId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedRoomId,
      decoration: AppInputDecoration.dropdown(
        hintText: 'Select meeting room',
      ),
      items: rooms.map((room) {
        return DropdownMenuItem<int>(
          value: room.MeetingRoomId,
          child: Text(room.MeetingRoomName),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Select meeting room';
        }

        return null;
      },
      onChanged: onChanged,
    );
  }
}
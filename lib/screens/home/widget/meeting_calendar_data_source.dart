import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../model/meeting_detail.dart';

class MeetingCalendarDataSource extends CalendarDataSource {
  MeetingCalendarDataSource(List<MeetingDetail> meetings) {
    appointments =
        meetings.map((meeting) {
          final start = _parseDate(meeting.startDateTime);
          final end = _parseDate(meeting.endDateTime);

          return Appointment(
            startTime: start,
            endTime: end,
            subject: meeting.purpose,
            location: meeting.roomName,
            color: _getRoomColor(meeting.meetingRoomId),
            id: meeting.bookingId,
            notes: '${meeting.bookedBy}~${meeting.deptName}~${meeting.bookedById.toUpperCase()}',

            //recurrenceRule: meeting.floors,
            //startTimeZone: meeting.deptName,
          );
        }).toList();
  }

  MeetingDetail? getMeeting(Appointment appointment) {
    final id = appointment.id;

    if (id is! int || id < 0 || id >= appointments!.length) {
      return null;
    }

    return appointments?[id];
  }

  DateTime _parseDate(String value) {
    return DateFormat('M/d/yyyy h:mm:ss a').parse(value);
  }

  Color _getRoomColor(int roomId) {
    switch (roomId) {
      case 100:
        return Colors.blue;
      case 101:
        return Colors.green;
      case 102:
        return Colors.orange;
      case 103:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}

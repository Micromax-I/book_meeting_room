import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../model/meeting_detail.dart';
import 'meeting_calendar_data_source.dart';

class MeetingDayCalendar extends StatelessWidget {
  final List<MeetingDetail> meetings;

  const MeetingDayCalendar({super.key, required this.meetings});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SfCalendar(
          view: CalendarView.day,
          onTap: (CalendarTapDetails details) {
            if (details.targetElement == CalendarElement.appointment) {
              final appointment = details.appointments!.first as Appointment;

              _showBookingDetails(context, appointment);
            }
          },

          dataSource: MeetingCalendarDataSource(meetings),

          timeSlotViewSettings: const TimeSlotViewSettings(
            startHour: 9,
            endHour: 18.5,

            timeInterval: Duration(minutes: 30),

            timeFormat: 'HH:mm',

            timeRulerSize: 55,

            // Makes the calendar responsive
            timeIntervalHeight: -1,
          ),

          appointmentBuilder: _appointmentBuilder,

          showCurrentTimeIndicator: false,

          todayHighlightColor: Colors.blue,

          headerHeight: 50,

          headerStyle: const CalendarHeaderStyle(
            textAlign: TextAlign.center,

            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  void _showBookingDetails(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: buildMeetingDetailsCard(appointment),
          ),
        );
      },
    );
  }

  Widget _appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    if (details.appointments.isEmpty) {
      return const SizedBox.shrink();
    }

    final appointment = details.appointments.first as Appointment;

    final height = details.bounds.height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),

      child: Container(
        width: double.infinity,
        height: double.infinity,

        padding: const EdgeInsets.all(5),

        color: appointment.color,

        child: _buildResponsiveAppointment(appointment, height),
      ),
    );
  }

  Widget _buildResponsiveAppointment(Appointment appointment, double height) {
    // Very small appointment
    if (height < 40) {
      return Text(
        appointment.subject,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // Medium appointment
    if (height < 70) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisSize: MainAxisSize.min,

        children: [
          Text(
            appointment.subject,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (appointment.location != null)
            Text(
              appointment.location!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(color: Colors.white, fontSize: 9),
            ),
        ],
      );
    }

    // Large appointment
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      mainAxisSize: MainAxisSize.min,

      children: [
        Text(
          appointment.subject,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          appointment.notes ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,

          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }

  _buildRow(String label, String value) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  Widget buildMeetingDetailsCard(Appointment meeting) {
    final parts = meeting.notes?.split('~') ?? [];
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FBFF), Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.meeting_room_rounded,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meeting Room',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        meeting.location!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 12),

            // Details
            _buildDetailRow(
              Icons.meeting_room_outlined,
              'Room',
              meeting.location!,
            ),

            /* _buildDetailRow(
              Icons.business_outlined,
              'Building',
              meeting.building,
            ),*/

            /*_buildDetailRow(
              Icons.layers_outlined,
              'Floor',
              meeting.floors,
            ),*/
            _buildDetailRow(Icons.person_outline, 'Booked By', parts[0]),

            _buildDetailRow(Icons.groups_outlined, 'Department', parts[1]),

            _buildDetailRow(
              Icons.description_outlined,
              'Purpose',
              meeting.subject,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: Colors.blue),
          ),

          const SizedBox(width: 12),

          // Label
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          const Text(
            ': ',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),

          // Value
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              softWrap: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

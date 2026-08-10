import 'package:intl/intl.dart';

class TimeSlotHelper {
  static List<String> generateSlots({
    required DateTime selectedDate,
    int startHour = 9,
    int startMinute = 0,
    int endHour = 18,
    int endMinute = 0,
    int interval = 30,
  }) {
    final now = DateTime.now();

    final bool isToday =
        selectedDate.year == now.year &&
            selectedDate.month == now.month &&
            selectedDate.day == now.day;

    DateTime startTime;

    if (isToday) {
      startTime = _nextSlot(now);

      final officeStart = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startHour,
        startMinute,
      );

      if (startTime.isBefore(officeStart)) {
        startTime = officeStart;
      }
    } else {
      startTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startHour,
        startMinute,
      );
    }

    final endTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endHour,
      endMinute,
    );

    final slots = <String>[];

    while (!startTime.isAfter(endTime)) {
      slots.add(
        DateFormat('HH:mm').format(startTime),
      );

      startTime = startTime.add(
        Duration(minutes: interval),
      );
    }

    return slots;
  }

  static DateTime _nextSlot(DateTime now) {
    int hour = now.hour;
    int minute;

    if (now.minute == 0) {
      minute = 0;
    } else if (now.minute <= 30) {
      minute = 30;
    } else {
      hour++;
      minute = 0;
    }

    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
  }

  static List<String> generateToSlots(
      String fromTime, {
        int endHour = 18,
        int endMinute = 0,
        int interval = 30,
      }) {
    final format = DateFormat('HH:mm');

    var start = format
        .parse(fromTime)
        .add(Duration(minutes: interval));

    final end = DateTime(
      2026,
      1,
      1,
      endHour,
      endMinute,
    );

    final slots = <String>[];

    while (!start.isAfter(end)) {
      slots.add(format.format(start));

      start = start.add(
        Duration(minutes: interval),
      );
    }

    return slots;
  }
}
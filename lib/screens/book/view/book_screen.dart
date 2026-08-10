import 'package:book_meeting_room/model/meeting_room_model.dart';
import 'package:book_meeting_room/screens/book/viewmodel/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../util/preference_helper.dart';
import '../../../widget/common_app_bar.dart';
import '../../../widget/custom_date_picker_field.dart';
import '../../../widget/custom_text_form_field.dart';
import '../../../widget/ui_helper.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var from = TextEditingController();
  var to = TextEditingController();
  var date = TextEditingController();
  var building = TextEditingController();
  var floor = TextEditingController();
  var purpose = TextEditingController();
  final prefs = PreferenceHelper();
  String timeValue = "";
  String userId = "";
  String userName = "";
  TimeOfDay? exitTime;
  DateTime? _selectedDate;
  String? selectedType;
  String? meetingRoom;

  MeetingRoomModel? selectedRoom;
  int? selectedMeetingRoomId;

  String? selectedFromTime;
  String? selectedToTime;

  late List<String> fromSlots;

  // late List<String> toSlots;

  final InputDecoration dropdownDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColor.primary_color),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColor.primary_color),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColor.primary_color),
    ),
  );

  @override
  void initState() {
    super.initState();
    fromSlots = generateTimeSlots(startHour: 9, endHour: 18, interval: 30);
    // toSlots = generateTimeSlots(DateTime.now(), endHour: 18, interval: 30);
    Future.microtask(() {
      context.read<BookingViewModel>().loadMeetingRooms();
    });
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    building.text = 'PDA';
    floor.text = '1st Floor';
    final uN = await prefs.getString('userId') ?? '';
    final name = await prefs.getString('name') ?? '';
    setState(() {
      userId = uN;
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingViewModel>();
    return Scaffold(
      appBar: CommonAppBar(title: 'Book Meeting Room', showBack: false),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffE3F2FD), Colors.white],
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo_bg.png",
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "Book Your Room",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    /*Text(
                      "Safe • Fast • Comfortable",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),*/
                    SizedBox(height: 30),
                    Column(
                      children: [
                        DropdownButtonFormField<int>(
                          hint: Text('Select meeting room'),
                          decoration: dropdownDecoration,
                          value: selectedMeetingRoomId,
                          items:
                              vm.meetingRooms.map((room) {
                                return DropdownMenuItem<int>(
                                  value: room.MeetingRoomId,
                                  child: Text(room.MeetingRoomName),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMeetingRoomId = value;
                            });

                            print(selectedMeetingRoomId);
                          },
                        ),
                        SizedBox(height: 10),
                        CustomDatePickerField(
                          controller: date,
                          hintText: 'Select Date',
                          onTap: () => openCalenderView(context),
                          validator:
                              (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Select date'
                                      : null,
                        ),

                        SizedBox(height: 10),
                        _row('Building', building, Icons.apartment, true),

                        SizedBox(height: 10),
                        _row('Floor', floor, Icons.stairs, true),

                        SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: buildTimeDropdown(
                                from: true,
                                hint: 'Select From Time',
                                value: selectedFromTime,
                                validationMessage: 'Please select from time',
                                onChanged: (value) {
                                  setState(() {
                                    selectedFromTime = value;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: buildTimeDropdown(
                                from: false,
                                hint: 'Select To Time',
                                value: selectedToTime,
                                validationMessage: 'Please select to time',
                                onChanged: (value) {
                                  setState(() {
                                    selectedToTime = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        _row('Purpose', purpose, Icons.comment, false),
                        SizedBox(height: 10),

                        SizedBox(height: 40),
                        isLoading ? CircularProgressIndicator() : button(vm),
                      ],
                    ),
                    SizedBox(height: 20),
                    /* Row(
                      children: [
                        Icon(Icons.verified, color: Colors.green),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Your booking will be confirmed after approval.",
                          ),
                        ),
                      ],
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimeDropdown({
    required bool from,
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
    required String validationMessage,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: dropdownDecoration,
      hint: Text(hint),
      items:
          /*from
              ?*/
          fromSlots
              .map((time) => DropdownMenuItem(value: time, child: Text(time)))
              .toList(),
      /*: toSlots
                  .map(
                    (time) => DropdownMenuItem(value: time, child: Text(time)),
                  )
                  .toList()*/
      validator: (value) => value == null ? validationMessage : null,
      onChanged: onChanged /*(value) {
        setState(() {
          selectedFromTime = value;
          selectedToTime = null;
          toSlots = generateToSlots(value!, _selectedDate!);
        });
      }*/,
    );
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('hh:mm:ss a').format(dt); // or 'HH:mm'
  }

  Future<void> openCalenderView(BuildContext context) async {
    _selectedDate = null;
    var minDate = DateTime(2024, 6, 1);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: minDate,
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        /*fromSlots = generateTimeSlots(
          _selectedDate!,
          endHour: 17,
          interval: 30,
        );*/
        date.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Widget _row(
    String label,
    TextEditingController controller,
    IconData? prefixIcon,
    bool isDisable,
  ) {
    return
    /*Expanded(
          flex: 2,
          child: CustomText(
            text: label,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 15,
          ),
        ),*/
    CustomTextFormField(
      controller: controller,
      hintText: label,
      keyboardType: TextInputType.text,
      prefixIcon: prefixIcon,
      readOnly: isDisable,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter $label';
        }
        return null;
      },
    );
  }

  Future<void> addBooking(BookingViewModel vm) async {
    if (_formKey.currentState!.validate()) {
      final body = {
        'MeetingRoomId': selectedMeetingRoomId,
        'Building': building.text,
        'Floors': floor.text,
        'StartDateTime': "${date.text} ${selectedFromTime}:00",
        'EndDateTime': "${date.text} ${selectedToTime}:00",
        'Purpose': purpose.text,
        'CreatedBy': userId,
      };
      print('Body-->$body');

      final success = await vm.saveBookingRecord(body: body);
      print('Body-->success-->$success');
      if (success) {
        // Booking successful
        Navigator.pop(context);
      } else {
        // Show backend message
        UiHelper.showErrorDialog(context, vm.errorMessage);
      }
    }
  }

  button(BookingViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => addBooking(vm),
          icon: const Icon(Icons.meeting_room, color: Colors.white),
          label: const Text(
            "BOOK MEETING ROOM",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  /*List<String> generateTimeSlots({
    int startHour = 9,
    int endHour = 18,
    int interval = 30,
  }) {
    final List<String> slots = [];

    for (int hour = startHour; hour <= endHour; hour++) {
      slots.add('${hour.toString().padLeft(2, '0')}:00');

      if (hour != endHour) {
        slots.add('${hour.toString().padLeft(2, '0')}:30');
      }
    }

    return slots;
  }*/

  List<String> generateTimeSlots({
    int startHour = 9,
    int endHour = 18,
    int interval = 30,
  }) {
    final List<String> slots = [];

    DateTime current = DateTime(2026, 1, 1, startHour, 0);
    final DateTime end = DateTime(2026, 1, 1, endHour, 30);

    while (!current.isAfter(end)) {
      slots.add(
        '${current.hour.toString().padLeft(2, '0')}:'
        '${current.minute.toString().padLeft(2, '0')}',
      );

      current = current.add(Duration(minutes: interval));
    }

    return slots;
  }

  List<String> generateTimeSlots1(
    DateTime selectedDate, {
    int startHour = 9,
    int startMinute = 0,
    int endHour = 18,
    int endMinute = 0,
    int interval = 30,
  }) {
    final List<String> slots = [];

    final DateTime now = DateTime.now();

    final bool isToday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    DateTime startTime;

    if (isToday) {
      // Start from next available slot
      int hour = now.hour;
      int minute = now.minute;

      if (minute == 0) {
        minute = 0;
      } else if (minute <= 30) {
        minute = 30;
      } else {
        hour++;
        minute = 0;
      }

      startTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      // Don't allow slots before office start time
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

    while (!startTime.isAfter(endTime)) {
      slots.add(DateFormat('HH:mm').format(startTime));
      startTime = startTime.add(Duration(minutes: interval));
    }

    return slots;
  }

  List<String> generateToSlots(String fromTime, DateTime selectedDate) {
    final format = DateFormat('HH:mm');

    DateTime start = format.parse(fromTime).add(const Duration(minutes: 30));

    final end = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      18,
      0,
    );

    final List<String> slots = [];

    while (!start.isAfter(end)) {
      slots.add(format.format(start));
      start = start.add(const Duration(minutes: 30));
    }

    return slots;
  }
}

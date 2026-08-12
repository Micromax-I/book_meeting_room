import 'package:book_meeting_room/core/widget/logo_ui.dart';
import 'package:book_meeting_room/screens/book/viewmodel/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_viewmodel.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/time_slot_helper.dart';
import '../../../core/widget/button_ui.dart';
import '../../../util/preference_helper.dart';
import '../../../widget/common_app_bar.dart';
import '../../../widget/custom_date_picker_field.dart';
import '../../../widget/custom_text_form_field.dart';
import '../../../widget/ui_helper.dart';
import '../widget/booking_room_dropdown.dart';
import '../widget/booking_time_dropdown.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final _formKey = GlobalKey<FormState>();

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final purposeController = TextEditingController();

  final prefs = PreferenceHelper();

  String userId = '';
  String userName = '';

  int? selectedMeetingRoomId;
  String? selectedFromTime;
  String? selectedToTime;

  DateTime? selectedDate;

  List<String> fromSlots = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    buildingController.text = 'PDA';
    floorController.text = '1st Floor';

    await _loadUserData();

    if (!mounted) return;

    context.read<BookingViewModel>().loadMeetingRooms();

    _generateInitialTimeSlots();
  }

  Future<void> _loadUserData() async {
    userId = await prefs.getString('userId') ?? '';
    userName = await prefs.getString('name') ?? '';
  }

  void _generateInitialTimeSlots() {
    fromSlots = TimeSlotHelper.generateSlots(
      selectedDate: DateTime.now(),
      startHour: 9,
      endHour: 18,
      endMinute: 30,
      interval: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingViewModel>();

    return Scaffold(
      appBar: CommonAppBar(title: 'Book Meeting Room', showBack: false),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(BookingViewModel vm) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffE3F2FD), Colors.white],
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildHeader(),

                const SizedBox(height: 30),

                _buildBookingForm(vm),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        LogoUi(),

        /* Image.asset(
          'assets/images/logo_bg.png',
          height: 120,
          fit: BoxFit.contain,
        ),*/
        const Text(
          'Book Your Room',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBookingForm(BookingViewModel vm) {
    return Column(
      children: [
        BookingRoomDropdown(
          rooms: vm.meetingRooms,
          selectedRoomId: selectedMeetingRoomId,
          onChanged: (value) {
            setState(() {
              selectedMeetingRoomId = value;
            });
          },
        ),

        const SizedBox(height: 10),

        CustomDatePickerField(
          controller: dateController,
          hintText: 'Select Date',
          onTap: _selectDate,
          validator: _requiredValidator('Select date'),
        ),

        const SizedBox(height: 10),

        _buildBuildingField(),

        const SizedBox(height: 10),

        _buildFloorField(),

        const SizedBox(height: 10),

        _buildTimeFields(),

        const SizedBox(height: 10),

        _buildPurposeField(),

        const SizedBox(height: 40),

        _buildBookButton(vm),
      ],
    );
  }

  Widget _buildBuildingField() {
    return CustomTextFormField(
      controller: buildingController,
      hintText: 'Building',
      keyboardType: TextInputType.text,
      prefixIcon: Icons.apartment,
      readOnly: false,
      validator: _requiredValidator('Enter Building'),
    );
  }

  Widget _buildFloorField() {
    return CustomTextFormField(
      controller: floorController,
      hintText: 'Floor',
      keyboardType: TextInputType.text,
      prefixIcon: Icons.stairs,
      readOnly: false,
      validator: _requiredValidator('Enter Floor'),
    );
  }

  Widget _buildPurposeField() {
    return CustomTextFormField(
      controller: purposeController,
      hintText: 'Purpose',
      keyboardType: TextInputType.text,
      prefixIcon: Icons.comment,
      readOnly: true,
      validator: _requiredValidator('Enter Purpose'),
    );
  }

  Widget _buildTimeFields() {
    return Row(
      children: [
        Expanded(
          child: BookingTimeDropdown(
            hint: 'From Time',
            value: selectedFromTime,
            items: fromSlots,
            validationMessage: 'Please select from time',
            onChanged: (value) {
              setState(() {
                selectedFromTime = value;
                // selectedToTime = null;
              });
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: BookingTimeDropdown(
            hint: 'To Time',
            value: selectedToTime,
            items: fromSlots,
            validationMessage: 'Please select to time',
            onChanged: (value) {
              setState(() {
                selectedToTime = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton(BookingViewModel vm) {
    if (vm.state == ViewState.loading) {
      return const CircularProgressIndicator();
    }

    return ButtonUi(
      icon: Icons.meeting_room,
      title: 'BOOK MEETING ROOM',
      onPressed: () => addBooking(vm),
    );
  }

  String? Function(String?) _requiredValidator(String message) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }

      return null;
    };
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024, 6, 1),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
      dateController.text = DateHelper.formatApiDate(picked);

      fromSlots = TimeSlotHelper.generateSlots(
        selectedDate: picked,
        startHour: 9,
        endHour: 18,
        endMinute: 30,
        interval: 30,
      );

      selectedFromTime = null;
      selectedToTime = null;
    });
  }

  Map<String, dynamic> _buildBookingRequest() {
    return {
      'MeetingRoomId': selectedMeetingRoomId,
      'Building': buildingController.text.trim(),
      'Floors': floorController.text.trim(),
      'StartDateTime': '${dateController.text} $selectedFromTime:00',
      'EndDateTime': '${dateController.text} $selectedToTime:00',
      'Purpose': purposeController.text.trim(),
      'CreatedBy': userId,
    };
  }

  Future<void> addBooking(BookingViewModel vm) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedFromTime == "18:30") {
      UiHelper.showErrorDialog(
        context,
        "Please select a valid From Time. 18:30 cannot be selected.",
      );
      return;
    }
    if(selectedFromTime == selectedToTime){
      UiHelper.showErrorDialog(
        context,
        "From time and To time can not be same",
      );
      return;
    }
    final fromMinutes = _timeToMinutes(selectedFromTime!);
    final toMinutes = _timeToMinutes(selectedToTime!);

    if (toMinutes <= fromMinutes) {
      UiHelper.showErrorDialog(
        context,
        "To time must be later than From time",
      );
      return;
    }

    final body = _buildBookingRequest();

    final success = await vm.saveBookingRecord(body: body);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      return;
    }

    UiHelper.showErrorDialog(context, vm.errorMessage);
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    buildingController.dispose();
    floorController.dispose();
    purposeController.dispose();

    super.dispose();
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return (hour * 60) + minute;
  }
}

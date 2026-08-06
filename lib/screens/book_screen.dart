import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/cab_model.dart';
import '../model/generic_response.dart';
import '../network/api_service_new.dart';
import '../util/alert.dart';
import '../util/preference_helper.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_date_picker_field.dart';
import '../widget/custom_text_form_field.dart';
import '../widget/custom_time_picker.dart';
import '../widget/ui_helper.dart';

class BookScreen extends StatefulWidget {
  final CabModel cabModel;

  const BookScreen({super.key, required this.cabModel});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var from = TextEditingController();
  var to = TextEditingController();
  var date = TextEditingController();
  var mobile = TextEditingController();
  final prefs = PreferenceHelper();
  String timeValue = "";
  String userId = "";
  String userName = "";
  TimeOfDay? exitTime;
  DateTime? _selectedDate;
  String? selectedType;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final uN = await prefs.getString('userId') ?? '';
    final name = await prefs.getString('name') ?? '';
    final CabAccess = await prefs.getInt('CabAccess') ?? 0;
    setState(() {
      userId = uN;
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.cabModel.vehiclenumber,
        showBack: false,
      ),
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
                      "Book Your Ride",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Safe • Fast • Comfortable",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 30),
                    Column(
                      children: [
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
                        CustomTimePicker(
                          label: "Select Time",
                          selectedTime: exitTime,

                          onTimeSelected: (time) {
                            setState(() {
                              exitTime = time;
                              timeValue = formatTimeOfDay(time);
                            });
                          },
                          validator:
                              (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Select time'
                                      : null,
                        ),
                        SizedBox(height: 10),
                        _row(
                          'Mobile No',
                          mobile,
                          TextInputType.number,
                          Icons.phone,
                        ),
                        SizedBox(height: 10),
                        _row(
                          'From Location',
                          from,
                          TextInputType.text,
                          Icons.location_on,
                        ),
                        SizedBox(height: 10),
                        _row('To Location', to, TextInputType.text, Icons.flag),
                        SizedBox(height: 40),
                        isLoading
                            ? CircularProgressIndicator()
                            : button()
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.verified, color: Colors.green),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Your booking will be confirmed after approval.",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
        date.text =
            '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Widget _row(
    String label,
    TextEditingController controller,
    TextInputType type,
    IconData? prefixIcon,
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
      keyboardType: type,
      prefixIcon: prefixIcon,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter $label';
        }
        return null;
      },
    );
  }

  void addBooking() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // hide keyboard
      setState(() => isLoading = true);

      final body = {
        'Ecode': userId,
        'Name': userName,
        'Mobile': mobile.text,
        'TravelDate': date.text,
        'TravelTime': timeValue,
        'FromLocation': from.text,
        'ToLocation': to.text,
        'VehicleNumber': widget.cabModel.vehiclenumber,
        'DriverName': widget.cabModel.drivername,
        'DriverMobile': widget.cabModel.drivermobile,
        'CreatedBy': userId,
      };
      print('Body-->$body');

      ApiServiceNew.post(
        endpoint: '/cab/bookingrequest',
        body: body,
        fromJson:
            (json) => GenericResponse<String>.fromJson(
              json,
              (json) => json.toString(),
            ),
        onSuccess: (response) {
          setState(() => isLoading = false);

          if (response.Status == 0) {
            UiHelper.showErrorDialog(context, response.message!);
          } else if (response.Status == 1) {
            showAlertDialog(
              context: context,
              message: response.message!,
              onOk: () {
                Navigator.pop(context, true);
              },
            );
          }
        },
        onError: (error) {
          setState(() => isLoading = false);
          UiHelper.showErrorDialog(context, error);
        },
      );
    }
  }

  button() {
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
          onPressed: addBooking,
          icon: const Icon(Icons.local_taxi, color: Colors.white),
          label: const Text(
            "BOOK CAB",
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
}

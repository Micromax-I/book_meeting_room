import 'package:flutter/material.dart';

import '../../model/booking_model.dart';
import '../../model/generic_response.dart';
import '../../network/api_service_new.dart';
import '../../util/preference_helper.dart';
import '../../widget/common_app_bar.dart';
import '../../widget/custom_text.dart';
import '../../widget/ui_helper.dart';
import '../user_layout.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final prefs = PreferenceHelper();
  String userId = "";
  String userName = "";
  bool isLoading = false;
  List<BookingModel> reqList = [];
  int isAdmin = 0;

  // final userActions = ["Complete", "Cancel"];
  final List<Map<String, dynamic>> userActions = [
    {"id": 3, "name": "Complete"},
    {"id": 2, "name": "Cancel"},
  ];
  final List<Map<String, dynamic>> adminActions = [
    {"id": 1, "name": "Approve"},
    {"id": 2, "name": "Reject"},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final uId = await prefs.getString('userName') ?? '';
    final name = await prefs.getString('name') ?? '';
    final cabAccess = await prefs.getInt('CabAccess') ?? 0;
    setState(() {
      userId = uId;
      userName = name;
      isAdmin = cabAccess;
      getCabData(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Requests", showBack: false),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffE3F2FD), Colors.white],
            ),
          ),
          child: Column(
            children: [
              UserLayout(userName: '$userName($userId)'),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: double.infinity,
                height: 1,
                color: Colors.grey.shade800, // line color
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => getCabData(userId),
                  child: ListView.builder(
                    itemCount: reqList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          shadowColor: getStatusColor(
                            reqList[index].Status,
                          ).withOpacity(0.70),
                          margin: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                openAddBookingScreen(reqList[index]);
                              },
                              child: Column(
                                children: [
                                  _buildUI(
                                    'Name',
                                    reqList[index].Name,
                                    "Mobile",
                                    reqList[index].Mobile,
                                    false,
                                  ),
                                  _buildUI(
                                    'Date',
                                    reqList[index].TravelDate,
                                    "Time",
                                    reqList[index].TravelTime,
                                    false,
                                  ),
                                  _buildUI(
                                    'From',
                                    reqList[index].FromLocation,
                                    "To",
                                    reqList[index].ToLocation,
                                    false,
                                  ),
                                  _buildUI(
                                    'Status',
                                    reqList[index].Status,
                                    "Vehicle",
                                    reqList[index].VehicleNumber,
                                    true,
                                  ),
                                  // SizedBox(height: 10),
                                  reqList[index].Status.toLowerCase() ==
                                          'cancelled'
                                      ? SizedBox.shrink()
                                      : _buildRow("Action", reqList[index]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "pending":
        return Colors.red;
      case "cancelled":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Widget _buildRow(String s, BookingModel reqList) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomText(
            text: '',
            fontWeight: FontWeight.bold,
            alignment: Alignment.topLeft,
            color: Colors.black,
            textAlign: TextAlign.start,
            fontSize: 13,
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              if (isAdmin == 1) {
                openActionWindow(adminActions, reqList);
              } else {
                openActionWindow(userActions, reqList);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 0,
                top: 0,
                right: 30,
                bottom: 5,
              ),
              child: CustomText(
                text: s,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 20,
                alignment: Alignment.topRight,
                textDecoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUI(
    String fLabel,
    String fValue,
    String sLabel,
    String sValue,
    bool colorText,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomText(
                  text: fLabel,
                  fontWeight: FontWeight.bold,
                  alignment: Alignment.topLeft,
                  color: Colors.black,
                  textAlign: TextAlign.start,
                  fontSize: 13,
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomText(
                  text: fValue,
                  color: colorText ? getStatusColor(fValue) : Colors.black,
                  fontSize: 10,
                  alignment: Alignment.topLeft,
                  textAlign: TextAlign.start,
                  left: 5,
                  fontWeight: colorText ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: CustomText(
                  text: sLabel,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  textAlign: TextAlign.start,
                  alignment: Alignment.topLeft,
                  fontSize: 13,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  text: sValue,
                  color: Colors.black,
                  fontSize: 10,
                  alignment: Alignment.topLeft,
                  left: 5,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> getCabData(String userId) async {
    setState(() => isLoading = true);

    final body = {'Ecode': userId};
    print('Body-->$body');

    ApiServiceNew.post(
      endpoint: '/cab/cabreq',
      body: body,
      fromJson:
          (json) => GenericResponse<List<BookingModel>>.fromJson(
            json,
            (json) =>
                (json as List<dynamic>)
                    .map(
                      (e) => BookingModel.fromJson(e as Map<String, dynamic>),
                    )
                    .toList(),
          ),
      onSuccess: (response) {
        setState(() => isLoading = false);

        if (response.Data == null || response.Data!.isEmpty) {
          // UiHelper.showErrorDialog(context, 'No Record Found');
        } else {
          setState(() {
            reqList.clear();
            reqList.addAll(response.Data!);
          });
        }
      },
      onError: (error) {
        setState(() => isLoading = false);
        UiHelper.showErrorDialog(context, error);
      },
    );
  }

  void openAddBookingScreen(BookingModel cab) {
    /* Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookScreen(cabModel: cab)),
    );*/
  }

  void openActionWindow(
    List<Map<String, dynamic>> actions,
    BookingModel reqList,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Action"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: actions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(actions[index]["name"]),
                  onTap: () {
                    int selectedId = actions[index]["id"];
                    Navigator.pop(context);
                    callActionAPI(selectedId, reqList);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void callActionAPI(int selectedId, BookingModel reqList) {
    setState(() => isLoading = true);

    final body = {
      'BookingID': reqList.BookingID,
      'StatusId': selectedId,
      'Createdby': userId,
    };
    print('Body-->$body');

    ApiServiceNew.post(
      endpoint: '/cab/reqapproved',
      body: body,
      fromJson:
          (json) =>
              GenericResponse<String>.fromJson(json, (json) => json.toString()),
      onSuccess: (response) {
        setState(() => isLoading = false);

        if (response.Status == 0) {
          UiHelper.showErrorDialog(context, response.message!);
        } else {
          UiHelper.showErrorDialog(context, response.message!);
        }
      },
      onError: (error) {
        setState(() => isLoading = false);
        UiHelper.showErrorDialog(context, error);
      },
    );
  }
}

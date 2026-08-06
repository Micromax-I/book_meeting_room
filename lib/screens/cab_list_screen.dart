import 'package:book_meeting_room/screens/booking_screen.dart';
import 'package:book_meeting_room/screens/user_layout.dart';
import 'package:flutter/material.dart';

import '../model/cab_model.dart';
import '../model/generic_response.dart';
import '../network/api_service_new.dart';
import '../util/preference_helper.dart';
import '../widget/common_app_bar.dart';
import '../widget/ui_helper.dart';

class CabListScreen extends StatefulWidget {
  const CabListScreen({super.key});

  @override
  State<CabListScreen> createState() => _CabListScreenState();
}

class _CabListScreenState extends State<CabListScreen> {
  final prefs = PreferenceHelper();
  String userId = "";
  String userName = "";
  bool isLoading = false;
  List<CabModel> cabList = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final uId = await prefs.getString('userName') ?? '';
    final name = await prefs.getString('name') ?? '';
    setState(() {
      userId = uId;
      userName = name;
      getCabData(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Book Cab", showBack: false),
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
                child: ListView.builder(
                  itemCount: cabList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        color: Colors.white,
                        elevation: 10,
                        shadowColor: Colors.red.shade50,
                        margin: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: InkWell(
                          onTap: () {
                            openAddBookingScreen(cabList[index]);
                          },
                          child: ListTile(
                            leading: UiHelper.CustomImage(img: 'car_icon.png'),
                            title: Text(cabList[index].vehivlename!),
                            subtitle: Text(cabList[index].vehiclenumber!),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getCabData(String userId) {
    setState(() => isLoading = true);

    final body = {'Ecode': userId};
    // print('Body-->$body');

    ApiServiceNew.get(
      endpoint: '/cab/getvehiclelist',
      fromJson:
          (json) => GenericResponse<List<CabModel>>.fromJson(
            json,
            (json) =>
                (json as List<dynamic>)
                    .map((e) => CabModel.fromJson(e as Map<String, dynamic>))
                    .toList(),
          ),
      onSuccess: (response) {
        setState(() => isLoading = false);

        if (response.Data == null || response.Data!.isEmpty) {
          // UiHelper.showErrorDialog(context, 'No Record Found');
        } else {
          setState(() {
            cabList.clear();
            cabList.addAll(response.Data!);
          });
        }
      },
      onError: (error) {
        setState(() => isLoading = false);
        UiHelper.showErrorDialog(context, error);
      },
    );
  }

  void openAddBookingScreen(CabModel cab) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingScreen(cabModel: cab)),
    );
  }
}

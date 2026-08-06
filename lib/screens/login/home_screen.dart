import 'package:book_meeting_room/model/meeting_detail.dart';
import 'package:flutter/material.dart';

import '../../model/generic_response.dart';
import '../../model/meeting_room_model.dart';
import '../../network/api_service_new.dart';
import '../../util/preference_helper.dart';
import '../../widget/common_app_bar.dart';
import '../../widget/ui_helper.dart';
import '../book_screen.dart';
import '../user_layout.dart';

class HomeScreen extends StatefulWidget {
  final int isAdmin;

  const HomeScreen({super.key, required this.isAdmin});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final prefs = PreferenceHelper();
  String userId = "";
  String userName = "";
  bool isLoading = false;
  List<MeetingDetail> bookedList = [];
  List<MeetingRoomModel> roomList = [];

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
      getMeetingRoomList();
      getCabData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Book Meeting Room", showBack: false),
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
                  itemCount: bookedList.length,
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
                            // openAddBookingScreen(bookedList[index]);
                          },
                          child: ListTile(
                            //leading: IconData,
                            title: Text(bookedList[index].Purpose!),
                            subtitle: Text(bookedList[index].RoomName!),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.event_note),

        onPressed: () async {
          openAddBookingScreen();
        },
      ),
    );
  }

  void getCabData() {
    setState(() => isLoading = true);

    ApiServiceNew.get(
      endpoint: '/roombooking/getbookedmeetingroomlist',
      fromJson:
          (json) => GenericResponse<List<MeetingDetail>>.fromJson(
            json,
            (json) =>
                (json as List<dynamic>)
                    .map(
                      (e) => MeetingDetail.fromJson(e as Map<String, dynamic>),
                    )
                    .toList(),
          ),
      onSuccess: (response) {
        setState(() => isLoading = false);

        if (response.Data == null || response.Data!.isEmpty) {
          // UiHelper.showErrorDialog(context, 'No Record Found');
        } else {
          setState(() {
            bookedList.clear();
            bookedList.addAll(response.Data!);
          });
        }
      },
      onError: (error) {
        setState(() => isLoading = false);
        UiHelper.showErrorDialog(context, error);
      },
    );
  }

  void getMeetingRoomList() {
    setState(() => isLoading = true);

    ApiServiceNew.get(
      endpoint: '/roombooking/getmeetingroomlist',
      fromJson:
          (json) => GenericResponse<List<MeetingRoomModel>>.fromJson(
            json,
            (json) =>
                (json as List<dynamic>)
                    .map(
                      (e) =>
                          MeetingRoomModel.fromJson(e as Map<String, dynamic>),
                    )
                    .toList(),
          ),
      onSuccess: (response) {
        setState(() => isLoading = false);

        if (response.Data == null || response.Data!.isEmpty) {
          // UiHelper.showErrorDialog(context, 'No Record Found');
        } else {
          setState(() {
            roomList.clear();

            roomList.addAll(response.Data!);
          });
        }
      },
      onError: (error) {
        setState(() => isLoading = false);
        UiHelper.showErrorDialog(context, error);
      },
    );
  }

  void openAddBookingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookScreen(meetingRoomList: roomList),
      ),
    );
  }
}

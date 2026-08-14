import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widget/greeting_header.dart';
import '../../../widget/common_app_bar.dart';
import '../../../widget/ui_helper.dart';
import '../../book/view/book_screen.dart';
import '../viewmodel/meeting_viewmodel.dart';
import '../widget/meeting_day_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final vm = context.read<MeetingViewModel>();
      context.read<MeetingViewModel>().loadBookedMeetingList();
      final savedData = vm.loadSavedData();
      final user = savedData.split('~');
      if (user.length >= 2) {
        userId = user[0];
        userName = user[1];
      }

      print('userId-->$userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MeetingViewModel>();

    return Scaffold(
      appBar: CommonAppBar(title: 'Book Meeting Room', showBack: false),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.event_note),

        onPressed: () async {
          openAddBookingScreen(vm);
        },
      ),

      body: RefreshIndicator(
        onRefresh: vm.refresh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const GreetingHeader(userName: "Alok"),

              const SizedBox(height: 30),

              Expanded(
                child: MeetingDayCalendar(
                  meetings: vm.bookedList,

                  onResult: (meetingId) async {
                    print('meetingId-->$meetingId');
                    Map<String, dynamic> body = {'Bookingid': meetingId};
                    final success = vm.deleteBooking(body: body);
                    if (!mounted) return;

                    if (await success) {
                      vm.loadBookedMeetingList();
                      return;
                    }

                    UiHelper.showErrorDialog(context, vm.errorMessage);
                  },
                  userId: userId,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openAddBookingScreen(MeetingViewModel vm) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookScreen()),
    );

    // Called when BookScreen is popped
    if (result == true) {
      await vm.loadBookedMeetingList();
    }
  }
}

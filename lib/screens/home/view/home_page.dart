import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_viewmodel.dart';
import '../../../core/widget/empty_state.dart';
import '../../../core/widget/greeting_header.dart';
import '../../../widget/common_app_bar.dart';
import '../../book/view/book_screen.dart';
import '../viewmodel/meeting_viewmodel.dart';
import '../widget/booked_room_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MeetingViewModel>().loadBookedMeetingList();
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
          openAddBookingScreen();
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

              Expanded(child: _buildBookingContent(vm)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingContent(MeetingViewModel vm) {
    if (vm.state == ViewState.loading) {
      print('-->_buildBookingContent-->loading');
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.state == ViewState.error) {
      print('-->_buildBookingContent-->error');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50),

            const SizedBox(height: 10),

            Text(vm.errorMessage, textAlign: TextAlign.center),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: vm.loadBookedMeetingList,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (vm.bookedList.isEmpty) {
      print('-->_buildBookingContent-->empty');
      return EmptyState(
        icon: Icons.event_note,
        title: "No Booking Yet",
        subtitle:
            "Tap the Book button to book your first meeting booking for the day.",
        buttonText: "Book Meeting Room",
        onPressed: () {
          openAddBookingScreen();
        },
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),

      itemCount: vm.bookedList.length,

      separatorBuilder: (_, __) => const SizedBox(height: 12),

      itemBuilder: (_, index) {
        final bookedRoom = vm.bookedList[index];
        print('-->_buildBookingContent-->bookedRoom> ${bookedRoom.roomName}');
        return BookedRoomCard(
          bookedRoom: bookedRoom,
          onTap: () {
            // Handle booking click
          },
        );
      },
    );
  }

  void openAddBookingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookScreen()),
    );
  }
}

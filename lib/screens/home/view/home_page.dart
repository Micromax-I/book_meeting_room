import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../core/showcase/app_tour_keys.dart';
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

  bool _isTourStarting = false;

  @override
  void initState() {
    super.initState();
    ShowcaseView.register(
      disableBarrierInteraction: true,
      onStart: (index, key) {
        // debugPrint('Showcase started: $index');
      },

      onComplete: (index, key) {
        // debugPrint('Showcase completed: $index');
      },

      onFinish: () {
        // debugPrint('Showcase finished');

        // You can save tour completed status here
        // if required.
      },

      onDismiss: (key) {
        // debugPrint('Showcase dismissed');
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final vm = context.read<MeetingViewModel>();

    try {
      await vm.loadBookedMeetingList();

      final savedData = vm.loadSavedData();

      final user = savedData.split('~');

      if (!mounted) return;

      if (user.length >= 2) {
        setState(() {
          userId = user[0];
          userName = user[1];
        });
      }

      debugPrint('userId --> $userId');
      debugPrint('userName --> $userName');
      if (!vm.isTourCompleted()) {
        _startTour();
      }
    } catch (e) {
      debugPrint('Error loading HomePage data: $e');
    }
  }

  void _startTour() {
    if (_isTourStarting) {
      return;
    }

    _isTourStarting = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      ShowcaseView.get().startShowCase([
        AppTourKeys.calendar,
        AppTourKeys.createMeeting,
      ]);

      _isTourStarting = false;
    });
  }

  void _skipTour() {
    ShowcaseView.get().dismiss();
  }

  void _nextTour() {
    ShowcaseView.get().next();
  }

  void _finishTour(MeetingViewModel vm) {
    ShowcaseView.get().dismiss();
    debugPrint('User completed application tour');
    vm.saveTourCompleted();
  }

  TextStyle get _titleStyle {
    return const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      height: 1.2,
    );
  }

  TextStyle get _descriptionStyle {
    return const TextStyle(color: Colors.white, fontSize: 15, height: 1.5);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MeetingViewModel>();
    return Scaffold(
      appBar: CommonAppBar(title: 'Book Meeting Room', showBack: false),
      floatingActionButton: Showcase(
        key: AppTourKeys.createMeeting,
        title: 'Book Meeting Room',
        description: 'Click this button to book a meeting room',
        targetBorderRadius: BorderRadius.circular(18),
        targetPadding: const EdgeInsets.all(6),
        overlayColor: Colors.white,
        overlayOpacity: 0.80,
        tooltipBackgroundColor: const Color(0xFF1E1E1E),
        tooltipBorderRadius: BorderRadius.circular(18),
        tooltipPadding: const EdgeInsets.all(20),
        titleTextStyle: _titleStyle,
        descTextStyle: _descriptionStyle,
        showArrow: true,
        tooltipActions: [
          TooltipActionButton(
            type: TooltipDefaultActionType.next,
            backgroundColor: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              _finishTour(vm);
            },
          ),
        ],
        child: FloatingActionButton(
          elevation: 6,
          child: const Icon(Icons.event_note, size: 28),
          onPressed: () async {
            await openAddBookingScreen(vm);
          },
        ),
      ),

      body: RefreshIndicator(
        onRefresh: vm.refresh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GreetingHeader(userName: userName.isEmpty ? "Alok" : userName),
              const SizedBox(height: 30),
              Expanded(
                child: Showcase(
                  key: AppTourKeys.calendar,
                  title: 'Booked Meeting details',
                  description:
                      'Choose a date to view and manage your meeting room bookings.',
                  targetBorderRadius: BorderRadius.circular(14),
                  targetPadding: const EdgeInsets.all(4),
                  overlayColor: Colors.black,
                  overlayOpacity: 0.80,
                  tooltipBackgroundColor: const Color(0xFF1E1E1E),
                  tooltipBorderRadius: BorderRadius.circular(18),
                  tooltipPadding: const EdgeInsets.all(20),
                  titleTextStyle: _titleStyle,
                  descTextStyle: _descriptionStyle,
                  showArrow: true,
                  tooltipActions: [
                    TooltipActionButton(
                      type: TooltipDefaultActionType.skip,
                      backgroundColor: Colors.transparent,
                      onTap: _skipTour,
                    ),
                    TooltipActionButton(
                      backgroundColor: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      onTap: _nextTour,
                      type: TooltipDefaultActionType.next,
                    ),
                  ],
                  child: MeetingDayCalendar(
                    meetings: vm.bookedList,
                    onResult: (meetingId) async {
                      debugPrint('meetingId --> $meetingId');
                      final Map<String, dynamic> body = {
                        'Bookingid': meetingId,
                      };
                      final success = await vm.deleteBooking(body: body);
                      if (!mounted) return;

                      if (success) {
                        await vm.loadBookedMeetingList();
                      } else {
                        UiHelper.showErrorDialog(context, vm.errorMessage);
                      }
                    },
                    userId: userId,
                  ),
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
    if (!mounted) return;

    if (result == true) {
      await vm.loadBookedMeetingList();
    }
  }

  @override
  void dispose() {
    ShowcaseView.get().unregister();
    super.dispose();
  }
}

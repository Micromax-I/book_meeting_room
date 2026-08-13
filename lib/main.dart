import 'package:book_meeting_room/repository/meeting_repository.dart';
import 'package:book_meeting_room/screens/book/viewmodel/booking_view_model.dart';
import 'package:book_meeting_room/screens/home/viewmodel/meeting_viewmodel.dart';
import 'package:book_meeting_room/screens/login/viewmodel/login_view_model.dart';
import 'package:book_meeting_room/screens/splash/splash_screen_new.dart';
import 'package:book_meeting_room/util/preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        Provider<MeetingRepository>(create: (_) => MeetingRepository()),

        ChangeNotifierProvider<LoginViewModel>(
          create:
              (context) => LoginViewModel(
                repository: context.read<MeetingRepository>(),
                prefs: PreferenceHelper(),
              ),
        ),
        ChangeNotifierProvider<MeetingViewModel>(
          create:
              (context) => MeetingViewModel(context.read<MeetingRepository>()),
        ),

        ChangeNotifierProvider<BookingViewModel>(
          create:
              (context) => BookingViewModel(context.read<MeetingRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreenNew(),
    );
  }
}

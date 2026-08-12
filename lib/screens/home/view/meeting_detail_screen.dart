import 'package:book_meeting_room/widget/common_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../model/meeting_detail.dart';

class MeetingDetailScreen extends StatelessWidget {
  final MeetingDetail appointment;

  MeetingDetailScreen({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Meeting Details', showBack: true),
      body: Container(child: Text('data')),
    );
  }
}

import 'package:flutter/material.dart';

import 'app_tour_keys.dart';

class AppTourManager {
  static List<GlobalKey> homeTourKeys() {
    return [AppTourKeys.calendar, AppTourKeys.createMeeting];
  }
}

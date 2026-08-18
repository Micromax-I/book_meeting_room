import 'package:book_meeting_room/repository/meeting_repository.dart';

import '../../../core/base/base_viewmodel.dart';
import '../../../model/meeting_room_model.dart';

class BookingViewModel extends BaseViewModel {
  final MeetingRepository repository;

  BookingViewModel(this.repository);

  List<MeetingRoomModel> meetingRooms = [];

  Future<void> loadMeetingRooms() async {
    try {
      setLoading();

      meetingRooms = (await repository.getMeetingRoomList())!;

      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<bool> saveBookingRecord({required Map<String, Object?> body}) async {
    try {
      setLoading();
      final response = await repository.saveBookingRecord(body: body);
      // print('Body-->response-->${response}');
      // print('Body-->response-->${response?.Status}');
      if (response?.Status == 1) {
        setSuccess();
        return true;
      }
      setError(response?.message ?? 'Some Error occurred while saving');

      notifyListeners();
      return false;
    } catch (e) {
      setError(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }
}

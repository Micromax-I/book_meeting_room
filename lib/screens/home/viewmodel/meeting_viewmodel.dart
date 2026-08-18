import '../../../core/base/base_viewmodel.dart';
import '../../../model/meeting_detail.dart';
import '../../../model/meeting_room_model.dart';
import '../../../repository/meeting_repository.dart';
import '../../../util/preference_helper.dart';

class MeetingViewModel extends BaseViewModel {
  final MeetingRepository repository;

  final PreferenceHelper prefs;

  MeetingViewModel({required this.repository, required this.prefs});

  List<MeetingDetail> bookedList = [];
  List<MeetingRoomModel> meetingRooms = [];

  Future<void> refresh() async {
    print('-->refresh');
    await loadBookedMeetingList();
  }

  String loadSavedData() {
    final userId = prefs.getString('userName') ?? '';
    final userName = prefs.getString('name') ?? '';

    print('userId-->$userId');
    print('userName-->$userName');

    return '$userId~$userName';
  }

  bool isTourCompleted() {
    return prefs.getBool('showcase_completed') ?? false;
  }

  void saveTourCompleted() {
    prefs.setBool('showcase_completed', true);
  }

  Future<void> loadBookedMeetingList() async {
    print('-->loadBookedMeetingList');
    try {
      setLoading();
      print('-->loadBookedMeetingList-->bookedList Size ${bookedList.length}');
      bookedList.clear();
      print(
        '-->loadBookedMeetingList-->bookedList after clear ${bookedList.length}',
      );
      final result = await repository.loadBookedMeetingList();
      print('-->loadBookedMeetingList-->result after assign ${result!.length}');
      bookedList = result!;
      print(
        '-->loadBookedMeetingList-->bookedList after assign ${bookedList.length}',
      );
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  /*Future<void> loadMeetingRooms() async {
    try {
      setLoading();

      meetingRooms = (await repository.getMeetingRoomList())!;

      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }*/

  Future<void> startStopMeeting() async {
    print('-->loadBookedMeetingList');
    try {
      setLoading();
      final result = await repository.loadBookedMeetingList();
      bookedList = result!;
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<bool> deleteBooking({required Map<String, Object?> body}) async {
    try {
      setLoading();
      final response = await repository.deleteBooking(body: body);
      print('Body-->response-->${response}');
      print('Body-->response-->${response?.Status}');
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

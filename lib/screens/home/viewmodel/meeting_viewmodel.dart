import '../../../core/base/base_viewmodel.dart';
import '../../../model/meeting_detail.dart';
import '../../../repository/meeting_repository.dart';

class MeetingViewModel extends BaseViewModel {
  final MeetingRepository repository;

  MeetingViewModel(this.repository);

  List<MeetingDetail> bookedList = [];

  Future<void> refresh() async {
    print('-->refresh');
    await loadBookedMeetingList();
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
}

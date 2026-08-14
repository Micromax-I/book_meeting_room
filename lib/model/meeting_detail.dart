class MeetingDetail {
  final int meetingRoomId;
  final int bookingId;
  final String roomName;
  final String building;
  final String floors;
  final String startDateTime;
  final String endDateTime;
  final String purpose;
  final String bookedBy;
  final String deptName;
  final String bookedById;

  MeetingDetail({
    required this.meetingRoomId,
    required this.bookingId,
    required this.roomName,
    required this.building,
    required this.floors,
    required this.startDateTime,
    required this.endDateTime,
    required this.purpose,
    required this.bookedBy,
    required this.deptName,
    required this.bookedById,
  });

  factory MeetingDetail.fromJson(Map<String, dynamic> json) {
    return MeetingDetail(
      meetingRoomId: json['MeetingRoomId'] ?? 0,
      bookingId: json['Bookingid'] ?? 0,
      roomName: json['RoomName'] ?? '',
      building: json['Building'] ?? '',
      floors: json['Floors'] ?? '',
      startDateTime: json['StartDateTime'] ?? '',
      endDateTime: json['EndDateTime'] ?? '',
      purpose: json['Purpose'] ?? '',
      bookedBy: json['Bookedby'] ?? '',
      deptName: json['DeptName'] ?? '',
      bookedById: json['BookedbyId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MeetingRoomId': meetingRoomId,
      'Bookingid': bookingId,
      'RoomName': roomName,
      'Building': building,
      'Floors': floors,
      'StartDateTime': startDateTime,
      'EndDateTime': endDateTime,
      'Purpose': purpose,
      'Bookedby': bookedBy,
      'DeptName': deptName,
      'BookedbyId': bookedById,
    };
  }
}

class MeetingDetail {
  final int meetingRoomId;
  final String roomName;
  final String building;
  final String floors;
  final String startDateTime;
  final String endDateTime;
  final String purpose;
  final String bookedBy;
  final String deptName;

  MeetingDetail({
    required this.meetingRoomId,
    required this.roomName,
    required this.building,
    required this.floors,
    required this.startDateTime,
    required this.endDateTime,
    required this.purpose,
    required this.bookedBy,
    required this.deptName,
  });

  factory MeetingDetail.fromJson(Map<String, dynamic> json) {
    return MeetingDetail(
      meetingRoomId: json['MeetingRoomId'] ?? 0,
      roomName: json['RoomName'] ?? '',
      building: json['Building'] ?? '',
      floors: json['Floors'] ?? '',
      startDateTime: json['StartDateTime'] ?? '',
      endDateTime: json['EndDateTime'] ?? '',
      purpose: json['Purpose'] ?? '',
      bookedBy: json['Bookedby'] ?? '',
      deptName: json['DeptName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MeetingRoomId': meetingRoomId,
      'RoomName': roomName,
      'Building': building,
      'Floors': floors,
      'StartDateTime': startDateTime,
      'EndDateTime': endDateTime,
      'Purpose': purpose,
      'Bookedby': bookedBy,
      'DeptName': deptName,
    };
  }
}

class MeetingDetail {
  final int MeetingRoomId;
  final String RoomName;
  final String Building;
  final String Floors;
  final String StartDateTime;
  final String EndDateTime;
  final String Purpose;
  final String Bookedby;
  final String DeptName;

  MeetingDetail({
    required this.MeetingRoomId,
    required this.RoomName,
    required this.Building,
    required this.Floors,
    required this.StartDateTime,
    required this.EndDateTime,
    required this.Purpose,
    required this.Bookedby,
    required this.DeptName,
  });

  factory MeetingDetail.fromJson(Map<String, dynamic> json) {
    return MeetingDetail(
      MeetingRoomId: json['MeetingRoomId'] ?? 0,
      RoomName: json['RoomName']?.toString() ?? "",
      Building: json['Building']?.toString() ?? "",
      Floors: json['Floors']?.toString() ?? "",
      StartDateTime: json['StartDateTime']?.toString() ?? "",
      EndDateTime: json['EndDateTime']?.toString() ?? "",
      Purpose: json['Purpose']?.toString() ?? "",
      Bookedby: json['Bookedby']?.toString() ?? "",
      DeptName: json['DeptName']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MeetingRoomId': MeetingRoomId,
      'RoomName': RoomName,
      'Building': Building,
      'Floors': Floors,
      'StartDateTime': StartDateTime,
      'EndDateTime': EndDateTime,
      'Purpose': Purpose,
      'Bookedby': Bookedby,
      'DeptName': DeptName,
    };
  }
}

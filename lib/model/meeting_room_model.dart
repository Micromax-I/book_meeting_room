class MeetingRoomModel {
  final int MeetingRoomId;
  final String MeetingRoomName;
  final String Building;
  final String Floors;

  MeetingRoomModel({
    required this.MeetingRoomId,
    required this.MeetingRoomName,
    required this.Building,
    required this.Floors,
  });

  factory MeetingRoomModel.fromJson(Map<String, dynamic> json) {
    return MeetingRoomModel(
      MeetingRoomId: json['MeetingRoomId'] ?? 0,
      MeetingRoomName: json['MeetingRoomName']?.toString() ?? "",
      Building: json['Building']?.toString() ?? "",
      Floors: json['Floors']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MeetingRoomId': MeetingRoomId,
      'MeetingRoomName': MeetingRoomName,
      'Building': Building,
      'Floors': Floors,
    };
  }
}

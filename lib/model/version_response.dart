class VersionResponse {
  final String? Message;
  final String? ESSPath;
  final String? Remid;

  VersionResponse({
    required this.Message,
    required this.ESSPath,
    required this.Remid,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    return VersionResponse(
      Message: json['Message'] ?? '',
      ESSPath: json['ESSPath'] ?? '',
      Remid: json['Remid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Message': Message,
      'ESSPath': ESSPath,
      'Remid': Remid,
    };
  }
}

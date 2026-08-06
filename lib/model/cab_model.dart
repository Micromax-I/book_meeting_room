class CabModel {
  final String vehivlename;
  final String vehiclenumber;
  final String drivername;
  final String drivermobile;

  CabModel({
    required this.vehivlename,
    required this.vehiclenumber,
    required this.drivername,
    required this.drivermobile,
  });

  factory CabModel.fromJson(Map<String, dynamic> json) {
    return CabModel(
      vehivlename: json['vehivlename']?.toString() ?? "",
      vehiclenumber: json['vehiclenumber']?.toString() ?? "",
      drivername: json['drivername']?.toString() ?? "",
      drivermobile: json['drivermobile']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehivlename': vehivlename,
      'vehiclenumber': vehiclenumber,
      'drivername': drivername,
      'drivermobile': drivermobile,
    };
  }
}

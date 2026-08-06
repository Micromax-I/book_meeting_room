class EmployeeResponse {
  final String? Ecode;
  final String? Name;
  final int? Cabaccess;

  EmployeeResponse({
    this.Ecode,
    this.Name,
    this.Cabaccess,
  });

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) {
    print("Employee JSON: $json");
    print("Cabaccess value: ${json['Cabaccess']}");
    print("Cabaccess type: ${json['Cabaccess'].runtimeType}");
    return EmployeeResponse(
      Ecode: json['Ecode'],
      Name: json['Name'],
      Cabaccess: int.tryParse(json['Cabaccess'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Ecode': Ecode,
      'Name': Name,
      'Cabaccess': Cabaccess,
    };
  }
}

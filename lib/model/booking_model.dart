class BookingModel {
  final String BookingID;
  final String EmpCode;
  final String Name;
  final String Mobile;
  final String TravelDate;
  final String TravelTime;
  final String FromLocation;
  final String ToLocation;
  final String Status;
  final String VehicleNumber;
  final String DriverName;
  final String DriverMobile;

  BookingModel({
    required this.BookingID,
    required this.EmpCode,
    required this.Name,
    required this.Mobile,
    required this.TravelDate,
    required this.TravelTime,
    required this.FromLocation,
    required this.ToLocation,
    required this.Status,
    required this.VehicleNumber,
    required this.DriverName,
    required this.DriverMobile,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      BookingID: json['BookingID']?.toString() ?? "",
      EmpCode: json['EmpCode']?.toString() ?? "",
      Name: json['Name']?.toString() ?? "",
      Mobile: json['Mobile']?.toString() ?? "",
      TravelDate: json['TravelDate']?.toString() ?? "",
      TravelTime: json['TravelTime']?.toString() ?? "",
      FromLocation: json['FromLocation']?.toString() ?? "",
      ToLocation: json['ToLocation']?.toString() ?? "",
      Status: json['Status']?.toString() ?? "",
      VehicleNumber: json['VehicleNumber']?.toString() ?? "",
      DriverName: json['DriverName']?.toString() ?? "",
      DriverMobile: json['DriverMobile']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BookingID': BookingID,
      'EmpCode': EmpCode,
      'Name': Name,
      'Mobile': Mobile,
      'TravelDate': TravelDate,
      'TravelTime': TravelTime,
      'FromLocation': FromLocation,
      'ToLocation': ToLocation,
      'Status': Status,
      'VehicleNumber': VehicleNumber,
      'DriverName': DriverName,
      'DriverMobile': DriverMobile,
    };
  }
}

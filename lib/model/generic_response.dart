class GenericResponse<T> {
  final int? Status;
  final String? message;
  final T? Data;

  GenericResponse({this.Status, this.message, this.Data});

  factory GenericResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return GenericResponse<T>(
      Status: json['Status'] as int?,
      message: json['message'] as String?,
      Data: json["Data"] == null ? null : fromJsonT.call(json["Data"]),
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'Status': Status,
      'message': message,
      'Data': Data != null ? toJsonT(Data as T) : null,
    };
  }
}

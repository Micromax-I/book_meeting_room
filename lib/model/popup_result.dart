class PopupResult {
  final String id;
  final String? bookingId;
  final String? userId;

  PopupResult({
    required this.id,
    required this.bookingId,
    required this.userId,
  });

  factory PopupResult.fromJson(Map<String, dynamic> json) {
    return PopupResult(
      id: json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'bookingId': bookingId, 'userId': userId};
  }
}

class ServerResponse {
  final String message;

  ServerResponse(this.message);

  factory ServerResponse.fromMap(Map<String, dynamic> json) => ServerResponse(
        json['message'],
      );

  factory ServerResponse.fromJson(Map<String, dynamic> json) => ServerResponse(
        json['message'],
      );

  Map toJson() => {
        'message': message,
      };
}

class ApiError {
  String error;

  ApiError({this.error});

  ApiError.fromJson(Map<String, dynamic> json) : error = json['status'];

  Map<String, dynamic> toJson() =>
      new Map<String, dynamic>().putIfAbsent('status', () => error);
}

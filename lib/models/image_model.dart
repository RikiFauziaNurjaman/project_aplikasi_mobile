class DogModel {
  final String message;
  final String status;

  DogModel({
    required this.message,
    required this.status,
  });

  factory DogModel.fromJson(Map<String, dynamic> json) {
    return DogModel(
      message: json['message'],
      status: json['status'],
    );
  }
}
class MessageModel {
  final bool isUser;
  final String message;
  final DateTime time;
  final bool isLoading;

  MessageModel({
    required this.isUser,
    required this.message,
    required this.time,
    this.isLoading = false,

  });


 Map<String, dynamic> toJson() => {
        'isUser': isUser,
        'message': message,
        'time': time.toIso8601String(),
        'isLoading': isLoading,
      };

   factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      isUser: json['isUser'],
      message: json['message'],
      time: DateTime.parse(json['time']),
      isLoading: json['isLoading']?? false,
    );
  }
}
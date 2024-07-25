class ChatModel {
  final int id;
  final String message;
  final String sender;
  final String reciever;
  final String? createdat;
  final String? updatedat;

  ChatModel({
    required this.id,
    required this.message,
    required this.reciever,
    required this.createdat,
    required this.updatedat,
    required this.sender,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      message: json['message'],
      reciever: json['reciever'],
      sender: json['sender'],
      updatedat: json['updated_at'],
      createdat: json['created_at'], 
    );
  }
}

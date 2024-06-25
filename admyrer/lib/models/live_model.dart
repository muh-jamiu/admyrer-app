class Livemodel {
  final int id;
  final String token;
  final String? avatar;
  final String? userId;
  final String? username;
  final String? updatedat;
  final String? createdat;
  final String? channel;

  Livemodel({
    required this.id,
    required this.token,
    this.userId,
    required this.username,
    required this.channel,
    this.avatar,
    this.updatedat,
    this.createdat,
  });

  factory Livemodel.fromJson(Map<String, dynamic> json) {
    return Livemodel(
      id: json['id'],
      token: json['token'],
      updatedat: json['updated_at'],
      createdat: json['created_at'],
      userId: json['userId'],
      avatar: json['avatar'],
      channel: json['channel'],
      username: json['username'], 
    );
  }
}

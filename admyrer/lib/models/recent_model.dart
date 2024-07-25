class RecentModel {
  final int? id;
  final List name;
  final List image;

  RecentModel({
    this.id,
    required this.name,
    required this.image,
  });

  factory RecentModel.fromJson(Map<String, dynamic> json) {
    return RecentModel(
      id: json['id'],
      name: json['message'],
      image: json['reciever'],
    );
  }
}

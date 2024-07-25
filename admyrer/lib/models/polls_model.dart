class PollsModel {
  final int? id;
  final String title;
  final String options;
  final String? createdAt;
  final String? updatedAt;

  PollsModel({
    this.id,
    required this.title,
    required this.options,
    this.updatedAt,
    this.createdAt,
  });

  factory PollsModel.fromJson(Map<String, dynamic> json) {
    return PollsModel(
      id: json['id'],
      title: json['title'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      options: json['options'],
    );
  }
}

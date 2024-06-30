class ReviewsModel {
  final int? id;
  final int? userId;
  final String? username;
  final String title;
  final String comment;
  final String? rating;
  final String? createdAt;
  final String? updatedAt;

  ReviewsModel({
    this.id,
    this.userId,
    this.username,
    required this.title,
    required this.comment,
    this.rating,
    this.updatedAt,
    this.createdAt,
  });

  factory ReviewsModel.fromJson(Map<String, dynamic> json) {
    return ReviewsModel(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      title: json['title'],
      comment: json['comment'],
      rating: json['rating'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
    );
  }
}

import 'dart:convert';

class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;
  final String? photos;
  final String address;
  final String gender;
  final String ipAddress;
  final String? type;
  final String phoneNumber;
  final double? lat;
  final double? lng;
  final String birthday;
  final String country;
  final String? lastSeen;
  final bool? verified;
  final int height;
  final String hairColor;
  final String? interest;
  final String state;
  final String location;
  final String relationship;
  final String workStatus;
  final String education;
  final String body;
  final String? character;
  final String ethnicity;
  final String? children;
  final String? friends;
  final String? pets;
  final String? liveWith;
  final String car;
  final String? religion;
  final String? smoke;
  final String? drink;
  final String? travel;
  final String? music;
  final String city;
  final String? hobby;
  final String? color;
  final int? hotCount;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.photos,
    required this.address,
    required this.gender,
    required this.ipAddress,
    this.type,
    required this.phoneNumber,
    this.lat,
    this.lng,
    required this.birthday,
    required this.country,
    this.lastSeen,
    this.verified,
    required this.height,
    required this.hairColor,
    this.interest,
    required this.state,
    required this.location,
    required this.relationship,
    required this.workStatus,
    required this.education,
    required this.body,
    this.character,
    required this.ethnicity,
    this.children,
    this.friends,
    this.pets,
    this.liveWith,
    required this.car,
    this.religion,
    this.smoke,
    this.drink,
    this.travel,
    this.music,
    required this.city,
    this.hobby,
    this.color,
    this.hotCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
      photos: json['photos'],
      address: json['address'],
      gender: json['gender'],
      ipAddress: json['ip_address'],
      type: json['type'],
      phoneNumber: json['phone_number'],
      lat: json['lat'] != null ? double.tryParse(json['lat'].toString()) : null,
      lng: json['lng'] != null ? double.tryParse(json['lng'].toString()) : null,
      birthday: json['birthday'],
      country: json['country'],
      lastSeen: json['lastseen'],
      verified: json['verified'] == true,
      height: json['height'],
      hairColor: json['hair_color'],
      interest: json['interest'],
      state: json['state'],
      location: json['location'],
      relationship: json['relationship'],
      workStatus: json['work_status'],
      education: json['education'],
      body: json['body'],
      character: json['character'],
      ethnicity: json['ethnicity'],
      children: json['children'],
      friends: json['friends'],
      pets: json['pets'],
      liveWith: json['live_with'],
      car: json['car'],
      religion: json['religion'],
      smoke: json['smoke'],
      drink: json['drink'],
      travel: json['travel'],
      music: json['music'],
      city: json['city'],
      hobby: json['hobby'],
      color: json['color'],
      hotCount: json['hot_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

import "dart:convert";

class UserModel {
  final int id;
  final String fullName;
  final String mobileNumber;
  final String pinNumber;
  final dynamic status;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.pinNumber,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  UserModel copyWith({
    int? id,
    String? fullName,
    String? mobileNumber,
    String? pinNumber,
    dynamic status,
    String? createdAt,
    String? updatedAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        pinNumber: pinNumber ?? this.pinNumber,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        fullName: json["full_name"],
        mobileNumber: json["mobile_number"],
        pinNumber: json["pin_number"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "full_name": fullName,
        "mobile_number": mobileNumber,
        "pin_number": pinNumber,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

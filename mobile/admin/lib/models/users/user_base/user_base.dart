abstract class UserBase {
  String? get id;
  String? get userName;
  String? get surnames;
  String? get phoneNumber;
  bool? get isActive;
  String? get userType;
  DateTime? get createdAt;

  Map<String, dynamic> toJson();
}
class UserProfile {
  String email;
  String name;
  String mobileNo;
  String address;
  String? profilePicture;

  UserProfile({
    required this.email,
    required this.name,
    required this.mobileNo,
    required this.address,
    this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      mobileNo: json["mobile_no"] ?? "",
      address: json["address"] ?? "",
      profilePicture: json["profile_picture"],
    );
  }
}
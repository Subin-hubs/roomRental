class Enquiry {
  String createdOn;
  String room;
  String roomName;
  String roomAvailability;
  String roomCity;
  String name;
  String mobileNo;
  String message;

  Enquiry({
    required this.createdOn,
    required this.room,
    required this.roomName,
    required this.roomAvailability,
    required this.roomCity,
    required this.name,
    required this.mobileNo,
    required this.message,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      createdOn: json["created_on"] ?? "",
      room: json["room"] ?? "",
      roomName: json["room_name"] ?? "",
      roomAvailability: json["room_availability"] ?? "",
      roomCity: json["room_city"] ?? "",
      name: json["name"] ?? "",
      mobileNo: json["mobile_no"] ?? "",
      message: json["message"] ?? "",
    );
  }
}
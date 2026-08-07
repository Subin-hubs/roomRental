import 'room_image.dart';

class Room {

  String createdOn;
  String id;
  String user;
  String category;
  String title;
  String description;
  String price;
  String city;
  String location;
  bool isAvailable;
  List<String> amenities;
  List<RoomImage> roomImage;

  Room({
    this.createdOn = "",
    this.id = "",
    this.user = "",
    this.category = "",
    this.title = "",
    this.description = "",
    this.price = "",
    this.city="",
    this.location="",
    this.isAvailable=false,
    this.amenities = const[],
    this.roomImage = const[],
});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      createdOn: json["created_on"],
      id: json["id"],
      user: json["user"],
      category: json["category"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      city: json["city"],
      location: json["location"],
      isAvailable: json["is_available"],
      amenities: List<String>.from(json["amenities"]),
      roomImage: (json["images"] as List)
          .map((image) => RoomImage.fromJson(image))
          .toList(),
    );
  }

}
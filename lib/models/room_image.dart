class RoomImage {
  String id;
  String url;

  RoomImage({
    this.id = "",
    this.url = "",
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      id: json["id"],
      url: json["url"],
    );
  }
}
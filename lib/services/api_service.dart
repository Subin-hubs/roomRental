import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:room_rental/models/room.dart';

class ApiService {
  final String baseUrl = "http://192.168.100.69:8000";

  Future<List<Room>> getRooms() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/room/list/"),
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final results = data["results"];

        return results
            .map<Room>((room) => Room.fromJson(room))
            .toList();
      }
    } catch (e) {
      print("API ERROR: $e");
    }

    return [];
  }
}
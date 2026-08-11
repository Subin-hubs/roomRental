import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:room_rental/models/room.dart';



class ApiService {

  final String baseUrl = "http://192.168.100.69:8000";

  String? accessToken;
  String? refreshToken;

  Future<List<Room>> getRooms() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/room/list/"),
      );

     /* print(response.body);*/

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

  Future<bool> sendEnquiry(String roomId, String message, String name, String mobileNo) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/profile/enquiry/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "room": roomId,
          "message": message,
          "name": name,
          "mobile_no": mobileNo,
        }),
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return true;
      }

      print("Enquiry failed: ${response.statusCode}");
      print(response.body);

      return false;
    } catch (e) {
      print("API ERROR: $e");
      return false;
    }
  }

  Future<bool> register(
      String name,
      String email,
      String address,
      String password,
      String password2,
      String mobileNo,
      ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/user/register/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "address": address,
          "password": password,
          "password2": password2,
          "mobile_no": mobileNo,
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      print("REGISTER ERROR: $e");
      return false;
    }
  }
  Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/user/login/"),
        headers: {
          "Content-Type": "application/json",

        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        accessToken = data["token"]["access"];
        refreshToken = data["token"]["refresh"];

        return {
          "access": accessToken,
          "refresh": refreshToken,
        };
      }
      return {};
    } catch (e) {
      print("LOGIN ERROR: $e");
      return {};
    }
  }


}
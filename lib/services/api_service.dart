import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import '../models/enquiry.dart';
import '../models/room.dart';
import '../models/user_profile.dart';



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

  Future<bool> sendEnquiry(
      String roomId,
      String message,
      String name,
      String mobileNo,
      ) async {
    try {
      await loadToken();

      print("ENQUIRY TOKEN: $accessToken");

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

      print("ENQUIRY STATUS: ${response.statusCode}");
      print("ENQUIRY RESPONSE: ${response.body}");


      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      }

      return false;
    } catch (e) {
      print("ENQUIRY ERROR: $e");
      return false;
    }
  }

  Future<bool> register(String name,
      String email,
      String address,
      String password,
      String password2,
      String mobileNo,) async {
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

  Future<Map<String, dynamic>> login(String email,
      String password,) async {
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
      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN RESPONSE: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300)  {
        final data = jsonDecode(response.body);

        accessToken = data["token"]["access"];
        refreshToken = data["token"]["refresh"];

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("accessToken", accessToken!);
        await prefs.setString("refreshToken", refreshToken!);

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

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("accessToken");
    refreshToken = prefs.getString("refreshToken");
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("accessToken");
    await prefs.remove("refreshToken");

    accessToken = null;
    refreshToken = null;
  }

  Future<List<Enquiry>> getMyEnquiries() async {
    try {
      await loadToken();

      final response = await http.get(
        Uri.parse("$baseUrl/api/profile/enquiryList/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      print("ENQUIRY STATUS: ${response.statusCode}");
      print("ENQUIRY TOKEN: $accessToken");
      print("ENQUIRY RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data["results"] as List;

        return results
            .map((item) => Enquiry.fromJson(item))
            .toList();
      }

      return [];
    } catch (e) {
      print("GET ENQUIRY ERROR: $e");
      return [];
    }
  }

  Future<UserProfile?> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/profile/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      print("PROFILE STATUS: ${response.statusCode}");
      print("PROFILE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return UserProfile.fromJson(data);
      }

      return null;
    } catch (e) {
      print("GET PROFILE ERROR: $e");
      return null;
    }
  }
  Future<UserProfile?> updateProfile(
      String name,
      String mobileNo,
      String address,
      ) async {
    try {
      await loadToken();

      final response = await http.put(
        Uri.parse("$baseUrl/api/profile/update/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "name": name,
          "mobile_no": mobileNo,
          "address": address,
        }),
      );

      print("UPDATE PROFILE STATUS: ${response.statusCode}");
      print("UPDATE PROFILE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return UserProfile.fromJson(data);
      }

      return null;
    } catch (e) {
      print("UPDATE PROFILE ERROR: $e");
      return null;
    }
  }
  Future<List<Room>> getMyRooms() async {
    try {
      await loadToken();

      final response = await http.get(
        Uri.parse("$baseUrl/api/profile/room/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      print("MY ROOMS STATUS: ${response.statusCode}");
      print("MY ROOMS RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final results = data["results"] as List;

        return results
            .map((item) => Room.fromJson(item))
            .toList();
      }

      return [];
    } catch (e) {
      print("GET MY ROOMS ERROR: $e");
      return [];
    }
  }
  Future<bool> deleteRoom(String roomId) async {
    try {
      await loadToken();

      final response = await http.delete(
        Uri.parse("$baseUrl/api/room/delete/$roomId/"),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      print("DELETE ROOM STATUS: ${response.statusCode}");
      print("DELETE ROOM RESPONSE: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("DELETE ROOM ERROR: $e");
      return false;
    }
  }
  Future<bool> updateRoom({
    required String roomId,
    required String title,
    required String description,
    required String price,
    required String location,
    required String city,
    required List<String> amenities,
    required bool isAvailable,
  }) async {
    try {
      await loadToken();

      final response = await http.put(
        Uri.parse("$baseUrl/api/room/update/$roomId/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "price": price,
          "location": location,
          "city": city,
          "amenities": amenities,
          "is_available": isAvailable,
        }),
      );

      print("UPDATE ROOM STATUS: ${response.statusCode}");
      print("UPDATE ROOM RESPONSE: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("UPDATE ROOM ERROR: $e");
      return false;
    }
  }
  Future<bool> addRoom({
    required String category,
    required String title,
    required String description,
    required String price,
    required String location,
    required String city,
    required List<String> amenities,
    required List<String> imagePaths,
  }) async {
    try {
      await loadToken();

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/api/room/add/"),
      );

      request.headers["Authorization"] = "Bearer $accessToken";

      // Normal fields
      request.fields["category"] = category;
      request.fields["title"] = title;
      request.fields["description"] = description;
      request.fields["price"] = price;
      request.fields["location"] = location;
      request.fields["city"] = city;

      // Amenities
      for (final amenity in amenities) {
        request.fields.addAll({
          "amenities": amenity,
        });
      }

      // Images
      for (final imagePath in imagePaths) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "images",
            imagePath,
          ),
        );
      }

      final response = await request.send();

      final responseBody =
      await response.stream.bytesToString();

      print("ADD ROOM STATUS: ${response.statusCode}");
      print("ADD ROOM RESPONSE: $responseBody");

      return response.statusCode == 201;
    } catch (e) {
      print("ADD ROOM ERROR: $e");
      return false;
    }
  }


}
import 'package:http/http.dart' as http;

import '../main.dart';



Future<void> main() async {


  final profile = await apiService.getProfile();

  print("NAME: ${profile?.name}");
  print("EMAIL: ${profile?.email}");
  print("PHONE: ${profile?.mobileNo}");
  print("ADDRESS: ${profile?.address}");

}

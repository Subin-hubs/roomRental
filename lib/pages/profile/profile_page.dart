import 'package:flutter/material.dart';
import 'package:room_rental/pages/auth/login_page.dart';
import 'package:room_rental/services/api_service.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [
      ElevatedButton(onPressed: () async {
        await apiService.logout();

        if(mounted){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
        }

      }, child: Text("Logout")),
    ],),);
  }
}

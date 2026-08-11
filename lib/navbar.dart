import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:room_rental/pages/enquiry/enquiry_page.dart';
import 'package:room_rental/pages/home/home_page.dart';
import 'package:room_rental/pages/profile/profile_page.dart';
import 'package:room_rental/pages/search/search_page.dart';


class Navbar extends StatefulWidget {
  int CurrentIndex = 0;
  bool Navigatation = false;
  Navbar(this.CurrentIndex, this.Navigatation);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {

  int CurrentIndex = 0;
  bool Navigatation = false;
  late PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement activate
    super.initState();
    CurrentIndex = widget.CurrentIndex;
    Navigatation = widget.Navigatation;

    if(Navigatation == true){
      _pageController = PageController(
        initialPage: widget.CurrentIndex,
      );
    }
  }
  final List<Widget> pages = const [

    Home(),
    SearchPage(),
    /*EnquiryPage(),*/
    ProfilePage(),

  ];



  _onTabTapped(int index) {

    /*log(index.toString());*/
    setState(() {
      CurrentIndex = index;
      Navigatation == true?
      index = widget.CurrentIndex:null;
    });

    /*  _pageController.animateToPage(index, duration: Duration(seconds: 2), curve: Curves.ease);
    */


    setState(() {
      Navigatation = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[CurrentIndex],
      bottomNavigationBar: BottomNavigationBar(currentIndex: CurrentIndex, onTap: _onTabTapped,
        selectedItemColor: Colors.blueAccent.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: "Home",),
          BottomNavigationBarItem(icon: Icon(Icons.copy),label: "Template",),
          /*BottomNavigationBarItem(icon: Icon(Icons.copy_all_outlined),label: "Resume",),*/
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined),label: "Profile",),
        ],
      ),
    );
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }
}
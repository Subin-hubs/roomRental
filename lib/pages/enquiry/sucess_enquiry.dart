import 'package:flutter/material.dart';
import 'package:room_rental/navbar.dart';

class sucessEnquiry extends StatelessWidget {
  final String roomTitle;

  const sucessEnquiry({super.key, required this.roomTitle});

  static const primaryGreen = Color(0xFF1B7A43);
  static const greenTint = Color(0xFFE8F5EC);
  static const textDark = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              const Spacer(flex: 3),

              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: greenTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 44, color: primaryGreen),
              ),

              const SizedBox(height: 28),

              const Text(
                "Enquiry Sent!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textDark),
              ),

              const SizedBox(height: 12),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 14.5, color: textGrey, height: 1.5),
                  children: [
                    const TextSpan(text: "Your enquiry for "),
                    TextSpan(
                      text: roomTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: textDark),
                    ),
                    const TextSpan(text: " has been sent successfully."),
                  ],
                ),
              ),

              const Spacer(flex: 4),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    "View My Enquiries",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Navbar(0, true)));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryGreen, width: 1.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: primaryGreen),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
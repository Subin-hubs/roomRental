import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:room_rental/pages/enquiry/sucess_enquiry.dart';
import '../../main.dart';
import '../../models/room.dart';
import '../../services/api_service.dart';

class EnquiryPage extends StatefulWidget {
  final Room room;

  EnquiryPage({
    super.key,
    required this.room,
  });

  @override
  State<EnquiryPage> createState() => _EnquiryPageState();

}

class _EnquiryPageState extends State<EnquiryPage> {
  final TextEditingController messageController = TextEditingController(
    text: "I am interested in this property. I would like to schedule a visit...",
  );
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  static const primaryGreen = Color(0xFF1B7A43);
  static const darkGreen = Color(0xFF145C33);
  static const background = Color(0xFFF7F7F5);
  static const textDark = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF6B7280);

  @override
  void dispose() {
    messageController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String get formattedPrice {
    final value = double.tryParse(widget.room.price) ?? 0;
    final wholePart = value.truncate().toString();

    final buffer = StringBuffer();
    for (int i = 0; i < wholePart.length; i++) {
      final posFromEnd = wholePart.length - i;
      buffer.write(wholePart[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }

  bool isSubmitting = false;


  @override
  Widget build(BuildContext context) {
    final hasImage = widget.room.roomImage.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        titleSpacing: 0,
        title: const Text(
          "Send Enquiry",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: hasImage
                          ? Image.network(widget.room.roomImage[0].url, fit: BoxFit.cover)
                          : Container(color: const Color(0xFFEDEDEA)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.room.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textDark),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 13, color: textGrey),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                "${widget.room.city}, ${widget.room.location}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.5, color: textGrey),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Rs. $formattedPrice/mo",
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: primaryGreen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "MESSAGE *",
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 5,
              style: const TextStyle(fontSize: 14, color: textDark),
              decoration: InputDecoration(
                filled: true,
                fillColor: background,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: primaryGreen, width: 1.3),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Name",
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              style: const TextStyle(fontSize: 14, color: textDark),
              decoration: InputDecoration(
                hintText: "Enter your name",
                hintStyle: const TextStyle(color: textGrey, fontSize: 14),
                filled: true,
                fillColor: background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: primaryGreen, width: 1.3),
                ),
              ),
            ),const SizedBox(height: 12),
            const Text(
              "Phone Number",
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 14, color: textDark),
              decoration: InputDecoration(
                hintText: "+977 98XXXXXXXX",
                hintStyle: const TextStyle(color: textGrey, fontSize: 14),
                filled: true,
                fillColor: background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: primaryGreen, width: 1.3),
                ),
              ),
            ),


            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                  if (messageController.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter a message");
                    return;
                  }
                  if (nameController.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter your name");
                    return;
                  }
                  if (phoneController.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter your phone number");
                    return;
                  }

                  setState(() => isSubmitting = true);

                  final success = await apiService.sendEnquiry(
                    widget.room.id,
                    messageController.text.trim(),
                    nameController.text.trim(),
                    phoneController.text.trim(),
                  );

                  if (!mounted) return;
                  setState(() => isSubmitting = false);

                  if (success == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => sucessEnquiry(roomTitle: widget.room.title),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Failed to send the Enquiry",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: const Color(0xFF2D2D2D),
                      textColor: Colors.white,
                      fontSize: 14,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                   backgroundColor: primaryGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  "Send Enquiry",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
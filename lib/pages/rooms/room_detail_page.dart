import 'package:flutter/material.dart';
import 'package:room_rental/pages/enquiry/enquiry_page.dart';

import '../../models/room.dart';

class RoomDetailPage extends StatefulWidget {
  final Room room;

  const RoomDetailPage({super.key, required this.room});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  final PageController _pageController = PageController();
  int currentImage = 0;

  static const primaryGreen = Color(0xFF1B7A43);
  static const darkGreen = Color(0xFF145C33);
  static const greenTint = Color(0xFFE8F5EC);
  static const textDark = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF6B7280);

  @override
  void dispose() {
    _pageController.dispose();
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

  String get formattedDate {
    final parsed = DateTime.tryParse(widget.room.createdOn);
    if (parsed == null) return widget.room.createdOn;

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return "${months[parsed.month - 1]} ${parsed.day}, ${parsed.year}";
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.room.roomImage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(images),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.room.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: textDark,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _availabilityBadge(widget.room.isAvailable),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: textGrey),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.room.city}, ${widget.room.location}",
                              style: const TextStyle(fontSize: 14, color: textGrey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "Rs. $formattedPrice",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: primaryGreen,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "/month",
                              style: TextStyle(fontSize: 14, color: textGrey, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _propertyInfoCard(),
                        const SizedBox(height: 24),
                        const Text(
                          "Description",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textDark),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.room.description,
                          style: const TextStyle(fontSize: 14, color: textGrey, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Amenities",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textDark),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.room.amenities
                              .map((amenity) => _amenityChip(amenity))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        _ownerCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _sendEnquiryButton(context),
    );
  }

  Widget _buildImageCarousel(List images) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Positioned.fill(
            child: images.isEmpty
                ? Container(color: const Color(0xFFEDEDEA))
                : PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) => setState(() => currentImage = index),
              itemBuilder: (context, index) {
                return Image.network(images[index].url, fit: BoxFit.cover);
              },
            ),
          ),
          Positioned(
            top: 44,
            left: 16,
            child: _circleButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
          ),
/*          Positioned(
            top: 44,
            right: 16,
            child: _circleButton(icon: Icons.favorite_border, onTap: () {}),
          ),*/
          if (images.length > 1)
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  final isActive = index == currentImage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          if (images.length > 1)
            Positioned(
              bottom: 14,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${currentImage + 1}/${images.length}",
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: textDark),
      ),
    );
  }

  Widget _availabilityBadge(bool isAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable ? greenTint : const Color(0xFFF0F0EC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAvailable ? "✓ Available" : "Unavailable",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isAvailable ? darkGreen : textGrey,
        ),
      ),
    );
  }

  Widget _propertyInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "PROPERTY INFO",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(Icons.sell_outlined, "Category", widget.room.category),
          const SizedBox(height: 12),
          _infoRow(Icons.calendar_today_outlined, "Posted", formattedDate),
          const SizedBox(height: 12),
          _infoRow(Icons.person_outline, "Owner", widget.room.user),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 17, color: textGrey),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13.5, color: textGrey)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: textDark),
        ),
      ],
    );
  }

  Widget _amenityChip(String amenity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        amenity,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textDark),
      ),
    );
  }

  Widget _ownerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "OWNER",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: greenTint,
                child: Text(
                  widget.room.user.isNotEmpty ? widget.room.user[0].toUpperCase() : "?",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: darkGreen),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.room.user,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textDark),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Property Owner",
                      style: TextStyle(fontSize: 12.5, color: textGrey),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: greenTint,
                  foregroundColor: darkGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Contact", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sendEnquiryButton(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>EnquiryPage(room: widget.room)));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: const Text(
            "Send Enquiry",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
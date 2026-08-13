import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:room_rental/services/api_service.dart';

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({super.key});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final ApiService apiService = ApiService();
  final ImagePicker imagePicker = ImagePicker();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final cityController = TextEditingController();
  final locationController = TextEditingController();

  String category = "Apartment";

  final List<String> categories = [
    "Apartment",
    "House",
    "Room",
    "Flat",
    "Studio",
  ];

  final List<String> availableAmenities = [
    "WiFi",
    "Parking",
    "Water",
    "Electricity",
    "Kitchen",
    "Furnished",
    "Security",
    "Balcony",
  ];

  final List<String> selectedAmenities = [];

  final List<XFile> selectedImages = [];

  bool isAdding = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    cityController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    final images = await imagePicker.pickMultiImage();

    if (images.isEmpty) return;

    if (images.length < 2 || images.length > 4) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select between 2 and 4 images"),
        ),
      );

      return;
    }

    setState(() {
      selectedImages
        ..clear()
        ..addAll(images);
    });
  }

  Future<void> addRoom() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    if (selectedImages.length < 2 || selectedImages.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select 2 to 4 images"),
        ),
      );
      return;
    }

    setState(() {
      isAdding = true;
    });

    final success = await apiService.addRoom(
      category: category,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      price: priceController.text.trim(),
      location: locationController.text.trim(),
      city: cityController.text.trim(),
      amenities: selectedAmenities,
      imagePaths: selectedImages.map((image) => image.path).toList(),
    );

    if (!mounted) return;

    setState(() {
      isAdding = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Room added successfully"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to add room"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF7F7F5);
    const green = Color(0xFF1B7A43);

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        title: const Text("Add Room"),
        backgroundColor: background,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _field(
              controller: titleController,
              label: "Title",
            ),

            _field(
              controller: descriptionController,
              label: "Description",
              maxLines: 4,
            ),

            _field(
              controller: priceController,
              label: "Price",
              keyboardType: TextInputType.number,
            ),

            _field(
              controller: cityController,
              label: "City",
            ),

            _field(
              controller: locationController,
              label: "Location",
            ),

            const SizedBox(height: 4),

            const Text(
              "Category",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: category,
                  isExpanded: true,
                  items: categories.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      category = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Amenities",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableAmenities.map((amenity) {
                final selected =
                selectedAmenities.contains(amenity);

                return FilterChip(
                  label: Text(amenity),
                  selected: selected,
                  selectedColor: const Color(0xFFE8F5EC),
                  checkmarkColor: green,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        selectedAmenities.add(amenity);
                      } else {
                        selectedAmenities.remove(amenity);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Room Images",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  "${selectedImages.length}/4",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImages,
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: selectedImages.isEmpty
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 35,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Select 2–4 images",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 110,
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(selectedImages[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isAdding ? null : addRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isAdding
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Add Room",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
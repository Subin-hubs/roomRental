import 'package:flutter/material.dart';
import 'package:room_rental/models/room.dart';
import 'package:room_rental/services/api_service.dart';

class EditRoomPage extends StatefulWidget {
  final Room room;

  const EditRoomPage({
    super.key,
    required this.room,
  });

  @override
  State<EditRoomPage> createState() => _EditRoomPageState();
}

class _EditRoomPageState extends State<EditRoomPage> {
  final ApiService apiService = ApiService();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController locationController;
  late TextEditingController cityController;

  late bool isAvailable;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.room.title);

    descriptionController =
        TextEditingController(text: widget.room.description);

    priceController =
        TextEditingController(text: widget.room.price);

    locationController =
        TextEditingController(text: widget.room.location);

    cityController =
        TextEditingController(text: widget.room.city);

    isAvailable = widget.room.isAvailable;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    locationController.dispose();
    cityController.dispose();

    super.dispose();
  }

  Future<void> updateRoom() async {
    setState(() {
      isSaving = true;
    });

    final success = await apiService.updateRoom(
      roomId: widget.room.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      price: priceController.text.trim(),
      location: locationController.text.trim(),
      city: cityController.text.trim(),
      amenities: widget.room.amenities,
      isAvailable: isAvailable,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Room updated successfully"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update room"),
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
        title: const Text("Edit Room"),
        backgroundColor: background,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
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

            const SizedBox(height: 8),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Room Available",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: isAvailable,
              activeColor: green,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving ? null : updateRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Save Changes",
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
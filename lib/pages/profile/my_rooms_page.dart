import 'package:flutter/material.dart';
import 'package:room_rental/models/room.dart';
import 'package:room_rental/services/api_service.dart';

import 'add_room_page.dart';
import 'edit_room_page.dart';

class MyRoomsPage extends StatefulWidget {
  const MyRoomsPage({super.key});

  @override
  State<MyRoomsPage> createState() => _MyRoomsPageState();
}

class _MyRoomsPageState extends State<MyRoomsPage> {
  final ApiService apiService = ApiService();

  List<Room> rooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {
    final result = await apiService.getMyRooms();

    if (!mounted) return;

    setState(() {
      rooms = result;
      isLoading = false;
    });
  }
  Future<void> _confirmDelete(Room room) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Room?"),
          content: Text(
            'Are you sure you want to delete "${room.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final success = await apiService.deleteRoom(room.id);

    if (!mounted) return;

    if (success) {
      setState(() {
        rooms.removeWhere((item) => item.id == room.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Room deleted successfully"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to delete room"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF7F7F5);
    const textDark = Color(0xFF1A1A1A);
    const textGrey = Color(0xFF6B7280);
    const primaryGreen = Color(0xFF1B7A43);

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        title: const Text(
          "My Rooms",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddRoomPage(),
                ),
              );

              if (added == true) {
                loadRooms();
              }
            },
          ),
        ],
      ),


      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: primaryGreen,
        ),
      )
          : rooms.isEmpty
          ? const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.home_work_outlined,
              size: 60,
              color: textGrey,
            ),
            SizedBox(height: 12),
            Text(
              "No rooms listed yet",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: loadRooms,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            return _buildRoomCard(rooms[index]);
          },
        ),
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    const textDark = Color(0xFF1A1A1A);
    const textGrey = Color(0xFF6B7280);
    const primaryGreen = Color(0xFF1B7A43);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5EC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.home_outlined,
                    size: 32,
                    color: primaryGreen,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),

                      const SizedBox(height: 6),



                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditRoomPage(room: room),
                                  ),
                                );

                                if (updated == true) {
                                  loadRooms();
                                }
                              },
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text("Edit"),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _confirmDelete(room);
                              },
                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: const Text("Delete"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(
                  Icons.currency_rupee,
                  size: 17,
                  color: primaryGreen,
                ),
                const SizedBox(width: 3),
                Text(
                  room.price,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: primaryGreen,
                  ),
                ),

                const Spacer(),

                _availabilityBadge(room.isAvailable),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              room.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: textGrey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _availabilityBadge(bool available) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: available
            ? const Color(0xFFE8F5EC)
            : const Color(0xFFFCE9E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        available ? "Available" : "Unavailable",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: available
              ? const Color(0xFF145C33)
              : const Color(0xFFB3261E),
        ),
      ),
    );
  }
}
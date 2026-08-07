import 'package:flutter/material.dart';

import '../../models/room.dart';
import '../../services/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();

  List<Room> rooms = [];
  List<Room> filteredRooms = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadRooms();
    searchController.addListener(applyFilter);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadRooms() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await apiService.getRooms();
      setState(() {
        rooms = data;
        filteredRooms = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Couldn't load rooms. Pull down to retry.";
        isLoading = false;
      });
    }
  }

  void applyFilter() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredRooms = rooms.where((room) {
        return room.title.toLowerCase().contains(query) ||
            room.city.toLowerCase().contains(query) ||
            room.location.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF7F7F5),
        title: const Text(
          "Room Rental",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadRooms,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search by title, city or location",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(child: buildBody()),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) => const _RoomCardSkeleton(),
      );
    }

    if (error != null) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Center(
            child: Text(error!, style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      );
    }

    if (filteredRooms.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          Icon(Icons.home_work_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Center(
            child: Text(
              rooms.isEmpty ? "No rooms available yet" : "No rooms match your search",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: filteredRooms.length,
      itemBuilder: (context, index) => _RoomCard(room: filteredRooms[index]),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;

  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF1D9E75).withOpacity(0.12),
                  ),
                  child: const Icon(Icons.house_rounded, color: Color(0xFF0F6E56), size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              "${room.city} • ${room.location}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rs. ${room.price}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F6E56),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomCardSkeleton extends StatelessWidget {
  const _RoomCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
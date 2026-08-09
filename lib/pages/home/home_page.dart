import 'package:flutter/material.dart';
import 'package:room_rental/widgets/room_card.dart';

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

  // BEFORE:
  // List rooms = [];
  // List filteredRooms = [];

  // AFTER:
  // Dart now knows these lists contain Room objects.
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
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
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

                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {

    // --------------------------------
    // 1. API IS STILL LOADING
    // --------------------------------

    if (isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),

        // Show 3 temporary cards
        itemCount: 3,

        itemBuilder: (context, index) {
          return const _RoomCardSkeleton();
        },
      );
    }

    // --------------------------------
    // 2. API ERROR
    // --------------------------------

    if (error != null) {
      return ListView(
        children: [
          const SizedBox(height: 80),

          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: Colors.grey,
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              error!,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      );
    }

    // --------------------------------
    // 3. NO ROOMS / NO SEARCH RESULTS
    // --------------------------------

    if (filteredRooms.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 80),

          Icon(
            Icons.home_work_outlined,
            size: 48,
            color: Colors.grey,
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              rooms.isEmpty
                  ? "No rooms available yet"
                  : "No rooms match your search",

              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      );
    }

    // --------------------------------
    // 4. SHOW ACTUAL ROOMS
    // --------------------------------

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

      // Number of rooms to display
      itemCount: filteredRooms.length,

      // Build one RoomCard for each room
      itemBuilder: (context, index) {

        return RoomCard(
          room: filteredRooms[index],
        );
      },
    );
  }
}


// ========================================
// LOADING SKELETON
// ========================================

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
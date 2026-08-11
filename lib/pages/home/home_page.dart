import 'package:flutter/material.dart';
import 'package:room_rental/pages/rooms/room_detail_page.dart';

import '../../main.dart';
import '../../models/room.dart';
import '../../services/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();

  List<Room> rooms = [];
  List<Room> filteredRooms = [];

  bool isLoading = true;
  String? error;
  String selectedCategory = "All";

  static const primaryGreen = Color(0xFF1B7A43);
  static const darkGreen = Color(0xFF145C33);
  static const greenTint = Color(0xFFE8F5EC);
  static const background = Color(0xFFF7F7F5);
  static const textDark = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF6B7280);

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
        final matchesQuery = room.title.toLowerCase().contains(query) ||
            room.city.toLowerCase().contains(query) ||
            room.location.toLowerCase().contains(query);

        final matchesCategory =
            selectedCategory == "All" || room.category == selectedCategory;

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void selectCategory(String category) {
    setState(() => selectedCategory = category);
    applyFilter();
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = searchController.text.isNotEmpty;
    final recentRooms = rooms.take(3).toList();

    final categories = <String>[
      "All",
      ...{for (final room in rooms) if (room.category.isNotEmpty) room.category},
    ];

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadRooms,
          color: primaryGreen,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$greeting 👋",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textGrey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Find your next home",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: textDark,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: greenTint,
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryGreen, width: 1.5),
                        ),
                        child: const Icon(Icons.person, color: darkGreen, size: 22),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search by title, city or location",
                      hintStyle: const TextStyle(color: textGrey, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: textGrey),
                      suffixIcon: isSearching
                          ? IconButton(
                        icon: const Icon(Icons.close, color: textGrey, size: 20),
                        onPressed: searchController.clear,
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: primaryGreen, width: 1.3),
                      ),
                    ),
                  ),
                ),
              ),

              if (categories.length > 1)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(left: 20, right: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category == selectedCategory;

                        return GestureDetector(
                          onTap: () => selectCategory(category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? primaryGreen : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? primaryGreen : const Color(0xFFE4E4E0),
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : textDark,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              if (!isSearching &&
                  selectedCategory == "All" &&
                  !isLoading &&
                  error == null &&
                  recentRooms.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recently Added",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textDark),
                        ),
                        Text(
                          "See all",
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: primaryGreen),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 250,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(left: 20, right: 4),
                      scrollDirection: Axis.horizontal,
                      itemCount: recentRooms.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 190,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoomDetailPage(room: recentRooms[index]),
                                ),
                              );
                            },
                            child: _RoomCard(room: recentRooms[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        isSearching || selectedCategory != "All" ? "Results" : "Available Rooms",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textDark),
                      ),
                      const SizedBox(width: 8),
                      if (!isLoading && error == null)
                        Text(
                          "${filteredRooms.length} found",
                          style: const TextStyle(fontSize: 13, color: textGrey),
                        ),
                    ],
                  ),
                ),
              ),

              buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => const _RoomCardSkeleton(),
            childCount: 3,
          ),
        ),
      );
    }

    if (error != null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              _iconCircle(Icons.wifi_off_rounded),
              const SizedBox(height: 16),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: textGrey, fontSize: 13.5),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: loadRooms,
                style: TextButton.styleFrom(
                  backgroundColor: greenTint,
                  foregroundColor: darkGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Retry", style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredRooms.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              _iconCircle(Icons.home_work_outlined),
              const SizedBox(height: 16),
              Text(
                rooms.isEmpty ? "No rooms available yet" : "No rooms match your search",
                style: const TextStyle(color: textGrey, fontSize: 13.5),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomDetailPage(room: filteredRooms[index]),
                    ),
                  );
                },
                child: _RoomCard(room: filteredRooms[index]),
              ),
            );
          },
          childCount: filteredRooms.length,
        ),
      ),
    );
  }

  Widget _iconCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(color: Color(0xFFF0F0EC), shape: BoxShape.circle),
      child: Icon(icon, size: 32, color: const Color(0xFF9CA3AF)),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;
  const _RoomCard({required this.room});

  static const primaryGreen = Color(0xFF1B7A43);
  static const darkGreen = Color(0xFF145C33);
  static const greenTint = Color(0xFFE8F5EC);
  static const textDark = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF6B7280);

  String get formattedPrice {
    final value = double.tryParse(room.price) ?? 0;
    final wholePart = value.truncate().toString();

    final buffer = StringBuffer();
    for (int i = 0; i < wholePart.length; i++) {
      final posFromEnd = wholePart.length - i;
      buffer.write(wholePart[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = room.roomImage.isNotEmpty;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: hasImage
                      ? Image.network(room.roomImage[0].url, fit: BoxFit.cover)
                      : Container(color: const Color(0xFFEDEDEA)),
                ),
              ),
/*              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 16, color: textDark),
                ),
              ),*/
              if (room.category.isNotEmpty)
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      room.category,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: textDark),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: textGrey),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        "${room.city}, ${room.location}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: textGrey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rs. $formattedPrice",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: primaryGreen),
                    ),
                    if (room.isAvailable)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: greenTint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "✓ Available",
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: darkGreen),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDEA),
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}
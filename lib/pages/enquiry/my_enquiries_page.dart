import 'package:flutter/material.dart';
import 'package:room_rental/models/enquiry.dart';
import 'package:room_rental/services/api_service.dart';

class MyEnquiriesPage extends StatefulWidget {
  const MyEnquiriesPage({super.key});

  @override
  State<MyEnquiriesPage> createState() => _MyEnquiriesPageState();
}

class _MyEnquiriesPageState extends State<MyEnquiriesPage> {
  final ApiService apiService = ApiService();

  List<Enquiry> enquiries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEnquiries();
  }

  Future<void> loadEnquiries() async {
    final result = await apiService.getMyEnquiries();

    if (!mounted) return;

    setState(() {
      enquiries = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF7F7F5);
    const textDark = Color(0xFF1A1A1A);
    const textGrey = Color(0xFF6B7280);



    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
        onRefresh: loadEnquiries,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My Enquiries",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${enquiries.length} enquiries sent",
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (enquiries.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text("No enquiries sent yet"),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final enquiry = enquiries[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildCard(enquiry),
                      );
                    },
                    childCount: enquiries.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildCard(Enquiry enquiry) {
    const textDark = Color(0xFF1A1A1A);
    const textGrey = Color(0xFF6B7280);

    String formatDate(String date) {
      final parsedDate = DateTime.tryParse(date);

      if (parsedDate == null) {
        return date;
      }

      const months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ];

      return "${months[parsedDate.month - 1]} ${parsedDate.day}, ${parsedDate.year}";
    }

    return Container(
      padding: const EdgeInsets.all(14),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEDEA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.home_outlined,
                  color: textGrey,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      enquiry.roomName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: textGrey,
                        ),
                        const SizedBox(width: 3),

                        Expanded(
                          child: Text(
                            enquiry.roomCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: textGrey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 12.5,
                          color: textGrey,
                        ),
                        const SizedBox(width: 4),

                        Text(
                          formatDate(enquiry.createdOn),
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: textGrey,
                          ),
                        ),

                        const SizedBox(width: 8),

                        _buildAvailabilityBadge(
                          enquiry.roomAvailability,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"${enquiry.message}"',
              style: const TextStyle(
                fontSize: 13,
                color: textGrey,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityBadge(String availability) {
    final isAvailable = availability.toLowerCase() == "true";

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: isAvailable
            ? const Color(0xFFE8F5EC)
            : const Color(0xFFFCE9E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAvailable ? "Available" : "Not Available",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isAvailable
              ? const Color(0xFF145C33)
              : const Color(0xFFB3261E),
        ),
      ),
    );
  }
}
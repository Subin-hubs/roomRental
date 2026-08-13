import 'package:flutter/material.dart';
import 'package:room_rental/models/user_profile.dart';

import '../../main.dart';
import '../../services/api_service.dart';
import 'edit_profile_page.dart';
import 'my_rooms_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const primaryGreen = Color(0xFF1B7A43);
  static const greenTint = Color(0xFFE8F5EC);
  static const background = Color(0xFFF7F7F5);
  static const textDark = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF6B7280);
  static const red = Color(0xFFE04B4B);
  static const redTint = Color(0xFFFCE9E9);

  final ApiService apiService = ApiService();

  UserProfile? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
    });

    await apiService.loadToken();

    final result = await apiService.getProfile();

    if (!mounted) return;

    setState(() {
      profile = result;
      isLoading = false;
    });
  }

  Future<void> handleLogout() async {
    // TODO: replace with your actual logout call
    // await AuthService().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: primaryGreen))
            : SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEDEDEA), width: 3),
                    ),
                    child: ClipOval(
                      child: profile?.profilePicture != null &&
                          profile!.profilePicture!.isNotEmpty
                          ? Image.network(
                        profile!.profilePicture!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: greenTint,
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: primaryGreen,
                          ),
                        ),
                      )
                          : Container(
                        color: greenTint,
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                profile?.name ?? "",
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: textDark),
              ),
              const SizedBox(height: 4),
              Text(
                  profile?.email ?? "",
                style: const TextStyle(fontSize: 13.5, color: textGrey),
              ),
              const SizedBox(height: 8),
              Text(
                  profile?.address ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: textGrey, height: 1.4),
              ),
              const SizedBox(height: 28),

              _buildMenuItem(
                icon: Icons.grid_view_rounded,
                title: "My Rooms",
                subtitle: "Manage your listings",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyRoomsPage()));
                },
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.chat_bubble_outline_rounded,
                title: "My Enquiries",
                subtitle: "View sent enquiries",
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.edit_outlined,
                title: "Edit Profile",
                subtitle: "Update your info",
                onTap: () async {
                  if (profile == null) return;

                  final updatedProfile = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        profile: profile!,
                      ),
                    ),
                  );

                  if (updatedProfile != null && mounted) {
                    setState(() {
                      profile = updatedProfile;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.vpn_key_outlined,
                title: "Change Password",
                subtitle: "Update your password",
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.logout_rounded,
                title: "Logout",
                subtitle: "Sign out of your account",
                onTap: handleLogout,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isDestructive ? Border.all(color: const Color(0xFFF6D3D3)) : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDestructive ? redTint : greenTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: isDestructive ? red : primaryGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: isDestructive ? red : textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12.5, color: textGrey),
                    ),
                  ],
                ),
              ),
              if (!isDestructive)
                const Icon(Icons.chevron_right_rounded, color: textGrey, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
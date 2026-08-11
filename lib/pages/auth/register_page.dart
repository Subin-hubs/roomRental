import 'package:flutter/material.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;
  String? errorMessage;

  static const primaryGreen = Color(0xFF1B7A43);
  static const greenTint = Color(0xFFE8F5EC);
  static const background = Color(0xFFF7F7F5);
  static const textDark = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF6B7280);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> handleSignup() async {

    final success = await apiService.register(nameController.text, emailController.text, addressController.text, passwordController.text, confirmPasswordController.text, mobileController.text);

    if (success){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }
    else{
      print("Register failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: greenTint,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.home_work_rounded, color: primaryGreen, size: 28),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Create account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textDark, letterSpacing: -0.5),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Sign up to start browsing rooms and flats",
                  style: TextStyle(fontSize: 14, color: textGrey),
                ),
                const SizedBox(height: 32),

                const Text(
                  "FULL NAME",
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 14, color: textDark),
                  decoration: _inputDecoration(hint: "Ramesh Shrestha"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Name is required";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  "EMAIL",
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14, color: textDark),
                  decoration: _inputDecoration(hint: "you@example.com"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Email is required";
                    if (!value.contains('@')) return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  "MOBILE NUMBER",
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 14, color: textDark),
                  decoration: _inputDecoration(hint: "+977 98XXXXXXXX"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Mobile number is required";
                    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.length < 10) return "Enter a valid mobile number";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  "ADDRESS",
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: addressController,
                  style: const TextStyle(fontSize: 14, color: textDark),
                  decoration: _inputDecoration(hint: "Chabahil, Kathmandu"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Address is required";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  "PASSWORD",
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style: const TextStyle(fontSize: 14, color: textDark),
                  decoration: _inputDecoration(hint: "At least 6 characters").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: textGrey,
                        size: 20,
                      ),
                      onPressed: () => setState(() => obscurePassword = !obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Password is required";
                    if (value.length < 6) return "Password must be at least 6 characters";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  "CONFIRM PASSWORD",
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: textGrey, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  style: const TextStyle(fontSize: 14, color: textDark),
                  decoration: _inputDecoration(hint: "Re-enter your password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: textGrey,
                        size: 20,
                      ),
                      onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                    ),
                  ),
                  validator: (value) {
                    if (value != passwordController.text) return "Passwords don't match";
                    return null;
                  },
                ),

                if (errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE9E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Color(0xFFB3261E), fontSize: 13),
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      disabledBackgroundColor: primaryGreen.withOpacity(0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4),
                    )
                        : const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ", style: TextStyle(fontSize: 13.5, color: textGrey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: primaryGreen),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFB3261E), width: 1.2),
      ),
    );
  }
}
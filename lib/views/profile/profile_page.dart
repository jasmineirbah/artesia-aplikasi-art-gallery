// lib/views/profile/profile_page.dart

import 'dart:io';
import 'package:artesia_aplikasi_art_gallery/utils/hash_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/session_service.dart';
import '../../services/database_service.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/primary_button.dart';
import 'nearby_gallery_sheet.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = AuthController();

  String username = "";
  String? imagePath;
  int? userId;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final user = await SessionService().getUser();

    if (user != null) {
      final userData =
          await DatabaseService.instance.getUserByName(user);

      setState(() {
        username = userData?.fullName ?? "User";
        imagePath = userData?.profileImage;
        userId = userData?.id;
      });
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null && userId != null) {
      setState(() => imagePath = picked.path);
      await authController.updateProfileImage(userId!, picked.path);
    }
  }

  Future<void> logout(BuildContext context) async {
    await SessionService().clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void showNearby(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NearbyGallerySheet(),
    );
  }

  void showEditUsernameDialog() {
    TextEditingController controller =
        TextEditingController(text: username);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Username"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () async {
              final newName = controller.text;

              await DatabaseService.instance.updateUsername(
                userId!,
                newName,
              );

              setState(() {
                username = newName;
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void showChangePasswordDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: TextField(
          controller: controller,
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newPass = controller.text;

              final hash = HashHelper.hashPassword(newPass);

              await DatabaseService.instance.updatePassword(
                userId!,
                hash,
              );

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppLogo(),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    imagePath != null ? FileImage(File(imagePath!)) : null,
                child: imagePath == null
                    ? const Icon(Icons.camera_alt)
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              username.isEmpty ? "Loading..." : username,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            _buildEditableItem(
              "Username",
              username,
              () => showEditUsernameDialog(),
            ),

            _buildEditableItem(
              "Password",
              "••••••••",
              () => showChangePasswordDialog(),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => showNearby(context),
              child: Column(
                children: [
                  Text(
                    "Nearby Galleries",
                    style: GoogleFonts.cormorantGaramond(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Container(width: 108, height: 2, color: const Color.fromARGB(255, 123, 120, 120)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "LOG OUT",
                onPressed: () => logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableItem(
    String title,
    String value,
    VoidCallback onEdit,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),

          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: onEdit,
              ),
            ],
          ),

          const Divider(),
        ],
      ),
    );
  }
}
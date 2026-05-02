// lib/views/profile/profile_page.dart

import 'dart:io';
import 'package:artesia_aplikasi_art_gallery/services/notification_preference.dart';
import 'package:artesia_aplikasi_art_gallery/utils/hash_helper.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/input_field.dart';
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
  bool isPasswordVisible = false;
  String tempPassword = "••••••••";
  bool isNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    loadUser();
    loadNotification();
  }

  void loadNotification() async {
    final value = await NotificationPreference.isEnabled();
    setState(() {
      isNotificationEnabled = value;
    });
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
    final controller = TextEditingController(text: username);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFBF9F4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              "Edit Username",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          content: TextField(
            controller: controller,
            style: GoogleFonts.inter(
              fontSize: 14, 
            ),
            decoration: InputDecoration(
              hintText: "Enter username",
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              filled: true,
              fillColor: Colors.white,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () async {
                final newName = controller.text.trim();

                if (newName.isEmpty) return;

                await DatabaseService.instance.updateUsername(
                  userId!,
                  newName,
                );

                await SessionService().saveUser(userId!, newName);

                setState(() {
                  username = newName;
                });

                Navigator.pop(dialogContext); 

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Username updated.")),
                );
              },
              child: Text(
                "Save",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showChangePasswordDialog() {
    final controller = TextEditingController();
    bool isObscure = true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFBF9F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Center(
                child: Text(
                  "Change Password",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              content: TextField(
                controller: controller,
                obscureText: isObscure,
                style: GoogleFonts.inter(
                  fontSize: 14, 
                ),
                decoration: InputDecoration(
                  hintText: "Enter new password",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  // ICON 
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      size: 18, 
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setStateDialog(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),

                  //
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 40,
                    minWidth: 40,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () async {
                    final newPass = controller.text.trim();

                    if (newPass.length < 6) return;

                    final hash = HashHelper.hashPassword(newPass);

                    await DatabaseService.instance.updatePassword(
                      userId!,
                      hash,
                    );

                    setState(() {
                      tempPassword = newPass;
                    });

                    Navigator.pop(dialogContext); 

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password updated.")),
                    );
                  },
                  child: Text(
                    "Save",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
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

            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      imagePath != null ? FileImage(File(imagePath!)) : null,
                  child: imagePath == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),

                // ICON EDIT 
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              username.isEmpty ? "Loading..." : username,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            _buildEditableItem(
              "Username",
              username,
              () => showEditUsernameDialog(),
            ),

            const SizedBox(height: 24),

            _buildPasswordItem(),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => showNearby(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    /// 🔹 TEXT (KIRI)
                    Expanded(
                      child: Text(
                        "Nearby Galleries",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    /// 🔹 ICON (KANAN)
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () => showNearby(context),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Notifications",
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      isNotificationEnabled
                          ? Icons.toggle_on
                          : Icons.toggle_off,
                      size: 45,
                      color: isNotificationEnabled
                          ? Colors.green
                          : Colors.grey,
                    ),
                    onPressed: () async {
                      final newValue = !isNotificationEnabled;

                      await NotificationPreference.setEnabled(newValue);

                      setState(() {
                        isNotificationEnabled = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
    return InputField(
      controller: TextEditingController(text: value),
      label: title.toUpperCase(),
      readOnly: true,

      suffixIcon: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.edit, size: 16),
        onPressed: onEdit,
      ),
    );
  }

  Widget _buildPasswordItem() {
    return InputField(
      controller: TextEditingController(
        text: isPasswordVisible ? tempPassword : "••••••••",
      ),
      label: 'PASSWORD',
      hintText: '',
      readOnly: true,
      obscureText: true,

      suffixIcon: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.edit, size: 16),
        onPressed: showChangePasswordDialog,
      ),
    );
  }
}
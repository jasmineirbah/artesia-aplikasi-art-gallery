import 'package:artesia_aplikasi_art_gallery/controllers/auth_controller.dart';
import 'package:artesia_aplikasi_art_gallery/views/auth/register_page.dart';
import 'package:artesia_aplikasi_art_gallery/views/auth/biometric_page.dart';
//import 'package:artesia_aplikasi_art_gallery/views/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/input_field.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/gallery_accent.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/app_logo.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/primary_button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authController = AuthController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController authController = AuthController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    final result = await _authController.login(
      fullName: _nameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));

    if (result.isSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BiometricPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),
                            const AppLogo(),
                            const SizedBox(height: 32),
                            Text(
                              'Log In',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 28,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Welcome back to the curated world of\ncontemporary art',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                height: 1.45,
                                color: const Color(0xFF6F6A64),
                              ),
                            ),
                            const SizedBox(height: 28),
                            const Center(child: GalleryAccent()),
                            const SizedBox(height: 42),
                            InputField(
                              controller: _nameController,
                              label: 'USERNAME',
                              hintText: 'Enter username',
                              textInputAction: TextInputAction.next,
                              validator: _authController.validateFullName,
                            ),

                            const SizedBox(height: 24),

                            InputField(
                              controller: _passwordController,
                              label: 'PASSWORD',
                              hintText: 'Enter password',
                              obscureText: _obscurePassword,
                              validator: _authController.validatePassword,
                              suffixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 16,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            
                            const SizedBox(height: 38),
                            PrimaryButton(
                              text: 'LOG IN',
                              isLoading: _isLoading,
                              onPressed: _submitLogin,
                            ),
                            const SizedBox(height: 44),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF6F6A64),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          final navigator = Navigator.of(
                                            context,
                                          );
                                          final messenger =
                                              ScaffoldMessenger.of(context);
                                          final registered = await navigator
                                              .push<bool>(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const RegisterPage(),
                                                ),
                                              );

                                          if (!mounted || registered != true) {
                                            return;
                                          }

                                          messenger.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Akun berhasil dibuat. Silakan login.',
                                              ),
                                            ),
                                          );
                                        },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(flex: 4),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


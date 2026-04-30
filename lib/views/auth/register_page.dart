import 'package:artesia_aplikasi_art_gallery/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/input_field.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/gallery_accent.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/app_logo.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/primary_button.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _authController = AuthController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    final result = await _authController.register(
      fullName: _fullNameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.isSuccess) {
      Navigator.of(context).pop(true);
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));
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
                            const AppLogo(showBackButton: true),
                            const SizedBox(height: 58),
                            const Center(child: GalleryAccent()),
                            const SizedBox(height: 28),
                            Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 28,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Join our curated community of art lovers',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF6F6A64),
                              ),
                            ),
                            const SizedBox(height: 38),
                            InputField(
                              controller: _fullNameController,
                              label: 'USERNAME',
                              hintText: 'write your name',
                              textInputAction: TextInputAction.next,
                              validator: _authController.validateFullName,
                            ),
                            const SizedBox(height: 24),
                            InputField(
                              controller: _passwordController,
                              label: 'PASSWORD',
                              hintText: '•••••••',
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
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
                            const SizedBox(height: 24),
                            InputField(
                              controller: _confirmPasswordController,
                              label: 'CONFIRM PASSWORD',
                              hintText: '•••••••',
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submitRegister(),
                              validator: (value) {
                                return _authController.validateConfirmPassword(
                                  value,
                                  _passwordController.text,
                                );
                              },
                              suffixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 16,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 38),
                            PrimaryButton(
                              text: 'SIGN UP',
                              isLoading: _isLoading,
                              onPressed: _submitRegister,
                            ),
                            const SizedBox(height: 30),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF6F6A64),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () => Navigator.of(context).pop(false),
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
                                    'Log In',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
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


import 'package:artesia_aplikasi_art_gallery/controllers/auth_controller.dart';
import 'package:artesia_aplikasi_art_gallery/views/auth/register_page.dart';
import 'package:flutter/material.dart';
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
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _showUnavailableMessage(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature belum tersedia.')));
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
                            const _LoginHeader(),
                            const Spacer(flex: 3),
                            Text(
                              'Log In',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 28,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Welcome back to the curated world of\ncontemporary art.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                height: 1.45,
                                color: const Color(0xFF6F6A64),
                              ),
                            ),
                            const SizedBox(height: 28),
                            const Center(child: _GalleryAccent()),
                            const SizedBox(height: 42),
                            _LoginInput(
                              controller: _nameController,
                              label: 'NAME',
                              hintText: 'your name',
                              textInputAction: TextInputAction.next,
                              validator: _authController.validateFullName,
                            ),
                            const SizedBox(height: 24),
                            _LoginInput(
                              controller: _passwordController,
                              label: 'PASSWORD',
                              hintText: '********',
                              obscureText: _obscurePassword,
                              validator: _authController.validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 18,
                                ),
                                color: const Color(0xFF9A948D),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  _showUnavailableMessage('Forgot password');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF6E6860),
                                  padding: const EdgeInsets.only(top: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 38),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submitLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  disabledBackgroundColor: Colors.black54,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'LOG IN',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
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
                            const _FooterCities(),
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

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.arrow_back, size: 18),
              color: Colors.black,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
          Text(
            'G A L L E R Y',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryAccent extends StatelessWidget {
  const _GalleryAccent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 66,
              height: 58,
              color: const Color(0xFFF8EBDD),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 0,
            child: Container(
              width: 78,
              height: 78,
              decoration: const BoxDecoration(
                color: Color(0xFFF3E3C5),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(72)),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 0,
            child: Container(
              width: 66,
              height: 96,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D8CC),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(72)),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 34,
              height: 34,
              color: const Color(0xFFF5C76E),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginInput extends StatelessWidget {
  const _LoginInput({
    required this.controller,
    required this.label,
    required this.hintText,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF76706B),
          ),
        ),
        TextFormField(
          controller: controller,
          textInputAction: textInputAction,
          obscureText: obscureText,
          validator: validator,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF928C86),
            ),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.only(top: 8, bottom: 8),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8C867F)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.4),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB45A4B)),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB45A4B), width: 1.4),
            ),
            errorStyle: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFFB45A4B),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterCities extends StatelessWidget {
  const _FooterCities();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(width: 1, height: 26, color: const Color(0xFFCFC8BE)),
        const SizedBox(height: 10),
        Text(
          'PARIS  -  NEW YORK  -  LONDON',
          style: GoogleFonts.inter(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFB6AEA4),
          ),
        ),
      ],
    );
  }
}

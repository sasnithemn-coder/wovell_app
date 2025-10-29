import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _signUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // prevents keyboard overflow
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF0D7C7C),
              Color(0xFF1A3A5C),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400.w),
                child: SingleChildScrollView(
                  // Allows small devices to scroll slightly if needed
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create Your',
                          style: TextStyle(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Container(
                        padding: EdgeInsets.all(22.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        child: Column(
                          children: [
                            _buildTextField(
                              'Name',
                              'Enter your name',
                              _nameController,
                            ),
                            SizedBox(height: 18.h),
                            _buildTextField(
                              'Email',
                              'Enter a valid email',
                              _emailController,
                              isEmail: true,
                            ),
                            SizedBox(height: 18.h),
                            _buildPasswordField(
                              'Password',
                              'Enter password',
                              _passwordController,
                              _obscurePassword,
                              () => setState(() =>
                                  _obscurePassword = !_obscurePassword),
                            ),
                            SizedBox(height: 18.h),
                            _buildPasswordField(
                              'Confirm Password',
                              'Re-enter password',
                              _confirmPasswordController,
                              _obscureConfirmPassword,
                              () => setState(() => _obscureConfirmPassword =
                                  !_obscureConfirmPassword),
                            ),
                            SizedBox(height: 28.h),
                            SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: ElevatedButton(
                                onPressed: _signUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF8C42),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26.r),
                                  ),
                                ),
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A3A5C),
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    String hint,
    TextEditingController controller,
    bool obscure,
    VoidCallback toggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A3A5C),
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
                size: 20.sp,
              ),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }
}

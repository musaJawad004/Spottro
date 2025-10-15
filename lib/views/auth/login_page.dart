import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/config.dart';
import '../../viewmodels/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authController.login(
        _emailController.text,
        _passwordController.text,
      );
      if (success) {
        Get.offAllNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConfig.defaultPaddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppConfig.spacingXLarge),
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    gradient: AppConfig.accentGradient,
                    borderRadius: BorderRadius.circular(AppConfig.cornerRadiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: AppConfig.primaryColorLight.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: AppConfig.iconSizeXLarge,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppConfig.spacingLarge),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: AppConfig.spacingSmall),
                Text(
                  'Sign in to continue discovering amazing places',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: AppConfig.spacingXLarge),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined, size: AppConfig.iconSizeMedium),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppConfig.surfaceDark
                        : AppConfig.surfaceLight,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppConfig.spacingMedium),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline, size: AppConfig.iconSizeMedium),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        size: AppConfig.iconSizeMedium,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppConfig.surfaceDark
                        : AppConfig.surfaceLight,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppConfig.spacingSmall),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.snackbar(
                        'Info',
                        'Password reset functionality coming soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppConfig.primaryColorLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppConfig.spacingLarge),
                Obx(() => SizedBox(
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.primaryColorLight,
                          foregroundColor: Colors.white,
                          elevation: AppConfig.elevationMedium,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
                          ),
                        ),
                        child: _authController.isLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: AppConfig.fontSizeSubtitle,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )),
                SizedBox(height: AppConfig.spacingLarge),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConfig.spacingMedium),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: AppConfig.spacingLarge),
                Row(
                  children: [
                    Expanded(
                      child: _SocialButton(
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        onPressed: () async {
                          await _authController.socialLogin('Google');
                          if (_authController.isAuthenticated) {
                            Get.offAllNamed('/home');
                          }
                        },
                      ),
                    ),
                    SizedBox(width: AppConfig.spacingMedium),
                    Expanded(
                      child: _SocialButton(
                        icon: Icons.apple,
                        label: 'Apple',
                        onPressed: () async {
                          await _authController.socialLogin('Apple');
                          if (_authController.isAuthenticated) {
                            Get.offAllNamed('/home');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConfig.spacingLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed('/register'),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: AppConfig.primaryColorLight,
                          fontWeight: FontWeight.bold,
                          fontSize: AppConfig.fontSizeBody,
                        ),
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
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 56.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark
                ? AppConfig.textSecondaryDark
                : AppConfig.textSecondaryLight,
            width: AppConfig.borderWidthThin,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppConfig.iconSizeMedium),
            SizedBox(width: AppConfig.spacingSmall),
            Text(
              label,
              style: TextStyle(fontSize: AppConfig.fontSizeBody),
            ),
          ],
        ),
      ),
    );
  }
}

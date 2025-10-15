import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/config.dart';
import '../../viewmodels/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_acceptTerms) {
      Get.snackbar(
        'Error',
        'Please accept the Terms & Conditions',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final success = await _authController.register(
        _nameController.text,
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConfig.defaultPaddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: AppConfig.spacingSmall),
                Text(
                  'Sign up to start discovering amazing places',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: AppConfig.spacingXLarge),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person_outline, size: AppConfig.iconSizeMedium),
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
                      return 'Please enter your name';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppConfig.spacingMedium),
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
                SizedBox(height: AppConfig.spacingMedium),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    prefixIcon: Icon(Icons.lock_outline, size: AppConfig.iconSizeMedium),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        size: AppConfig.iconSizeMedium,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
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
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppConfig.spacingMedium),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: AppConfig.primaryColorLight,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptTerms = !_acceptTerms;
                          });
                        },
                        child: Text.rich(
                          TextSpan(
                            text: 'I accept the ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                  color: AppConfig.primaryColorLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConfig.spacingLarge),
                Obx(() => SizedBox(
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading ? null : _handleRegister,
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
                                'Create Account',
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
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Sign In',
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

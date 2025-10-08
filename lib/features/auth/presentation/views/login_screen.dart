import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobarchy_flutter_app/core/utils/app_alerts.dart';
import 'package:jobarchy_flutter_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:jobarchy_flutter_app/features/auth/providers/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
      ),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the loginViewModelProvider to handle loading, success, and error states
    ref.listen<AsyncValue<bool>>(loginViewModelProvider, (previous, next) {
      next.when(
        data: (success) {
          if (success) {
            // Navigate to the home screen or another screen after successful login
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        loading: () {
          // Show loading indicator (optional)
        },
        error: (error, stackTrace) {
          // Error is handled in the ViewModel via AppAlerts.showError
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Colors.deepPurple, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Email", Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '';
                    if (!value.contains('@')) return '';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration("Password", Icons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '';
                    if (value.length < 6) return '';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Login Button
                Consumer(
                  builder: (context, ref, child) {
                    final loginState = ref.watch(loginViewModelProvider);
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: loginState.isLoading
                          ? null // Disable button during loading
                          : () {
                              if (_formKey.currentState!.validate()) {
                                // Call the login method from the ViewModel
                                ref
                                    .read(loginViewModelProvider.notifier)
                                    .login(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                              }
                            },
                      child: loginState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Login", // Changed from "Sign Up" to "Login"
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to the sign-up screen
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text("Sign Up"),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
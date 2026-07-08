import 'dart:async';
import 'package:flutter/material.dart';
import 'package:order_app/home_screen.dart';
import 'package:order_app/login_screen.dart';
import 'package:order_app/onboarding_screen.dart';
import 'package:order_app/providers/auth_provider.dart';
import 'package:order_app/services/local_storage.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 2), _navigateNext);
    });
  }

  void _navigateNext() {
    final auth = context.read<AuthProvider>();
    if (!LocalStorage.hasSeenOnboarding) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    if (auth.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              
             
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFF008A33), 
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.restaurant, 
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Restaurant',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B), 
                  letterSpacing: 0.5,
                ),
              ),
              const Text(
                'Orders',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008A33), 
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Manage restaurant orders\neasily and efficiently',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B), 
                  height: 1.4,
                ),
              ),
              
              const Spacer(flex: 2),

              const Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF008A33)),
                  ),
                ),
              ),
              
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
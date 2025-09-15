import 'package:flutter/material.dart';
import 'package:pawfect_care/features/onboarding/widgets/onboarding_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // Simulate loading process
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Navigate to onboarding screens
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingPage(
            title: 'Welcome to PawfectCare',
            description: 'Your one-stop shop for all pet care needs',
            imageAsset: 'assets/images/pet1.jpg',
          )),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


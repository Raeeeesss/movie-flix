import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../user/providers/user_preferences_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    );

    _scaleAnim = Tween<double>(begin: 0.82, end: 1.05).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _animController.stop();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final prefs = ref.read(userPreferencesProvider);
    try {
      if (prefs.isFirstTime) {
        context.go('/onboarding');
      } else {
        context.go('/home');
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnim,
              child: Transform.scale(
                scale: _scaleAnim.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Premium Custom Glowing Logo Emblem
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppConfig.primaryAccent,
                            const Color(0xFF5A0000),
                            AppColors.deepBlack,
                          ],
                          radius: 0.85,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppConfig.primaryAccent.withValues(alpha: 0.6),
                            blurRadius: 36,
                            spreadRadius: 6,
                          ),
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.6),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.gold,
                          size: 54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Configurable App Title
                    Text(
                      AppConfig.appName.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        color: AppColors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // AI Tagline Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.goldFaded,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.gold, size: 14),
                          SizedBox(width: 6),
                          Text(
                            AppConfig.appTagline,
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: AppColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

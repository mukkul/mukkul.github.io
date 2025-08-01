import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/'),
                        icon: Icon(
                          Icons.arrow_back,
                          color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Work Experience',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            _buildExperienceCard(
                              company: 'Kotak Securities',
                              position: 'Senior Manager',
                              duration: 'Apr 2024 - Present',
                              location: 'Mumbai',
                              responsibilities: [
                                'Team lead for development of Kotak Neo App using Flutter framework.',
                                'Responsible for Development, Deployment and Performance monitoring of the application.',
                                'Reviewing code quality with best practises, unit test cases and automation test cases.',
                                'Continuously connecting with team members for understanding technical problems and discussing quality and robust solutions thereby increasing team synergy.',
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildExperienceCard(
                              company: 'Lendingkart Technologies',
                              position: 'Senior Software Engineer',
                              duration: 'Jul 2022 - Apr 2024',
                              location: 'Bangalore',
                              responsibilities: [
                                'Spearheaded the development of Lendingkart Mobile App Flutter framework, followed Clean Architecture principles & Bloc State management for Reusability, Scalability and Flexibility along with Test-Driven Development (TDD) and Reusable Widgets.',
                                'Completely Built RMS Dashboard from scratch using Flutter web for Lendingkart\'s customer representatives to help customers resolve their issues.',
                                'Employ automation testing techniques (Robot Framework) to conduct comprehensive E2E test coverage, ensuring the application\'s reliability and stability.',
                                'Manage the end-to-end deployment process, utilizing CodeMagic (CI/CD) pipelines to streamline releases and monitor post-deployment to analyse impact.',
                                'Ensure the application consistently delivers a seamless experience to its 3-4k daily new users. Regularly engage with the App Analytics platforms like WebEngage, Google Analytics, Monitor app performance and user behaviour, and improvements to enhance the overall user experience.',
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildExperienceCard(
                              company: 'FitPhilia Solutions',
                              position: 'Software Engineer',
                              duration: 'Jan 2019 – Jul 2022',
                              location: 'Mumbai',
                              responsibilities: [
                                'Initiated and led the development of a Fitway CRM App using Flutter, building the application from the ground up and Delivered to 300+ Customers.',
                                'Seamlessly integrated Third-party SDK such as Razorpay, Firebase ML Kit, Google Maps etc along with REST API\'s . Followed Material Design Guidelines and developed Reusable UI Widgets.',
                                'Used Combination of Riverpod and GetX for state management and MVVM architecture.',
                                'Implemented strict linting rules and rigorous testing approach, writing Unit test cases, Widget test and RQT to improve code quality, and maintain a robust and reliable product. Deployed on platforms including iOS, Android and Web.',
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard({
    required String company,
    required String position,
    required String duration,
    required String location,
    required List<String> responsibilities,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        position,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppTheme.secondaryNeon : AppTheme.gradientEnd,
                          fontFamily: 'Exo2',
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppTheme.textSecondary : Colors.grey[600],
                        fontFamily: 'Exo2',
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppTheme.textSecondary : Colors.grey[600],
                        fontFamily: 'Exo2',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ...responsibilities.map((responsibility) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, right: 12),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      responsibility,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppTheme.textPrimary : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
} 
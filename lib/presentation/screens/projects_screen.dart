import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
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
                        'Independent Projects',
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
                            _buildProjectCard(
                              title: 'DailyDash Food Ordering & Subscription',
                              tech: 'Flutter',
                              description: 'Worked on the Food Order module, Containing Order and Payment Summary, Order History and New Order.',
                              features: [
                                'Food Order Module',
                                'Payment Summary',
                                'Order History',
                                'New Order System',
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildProjectCard(
                              title: 'Proxykhel Fantasy App',
                              tech: 'Flutter & CodeIgnitor',
                              description: 'Built Dream11 like a fantasy app single-handedly using flutter for iOS and Android.',
                              features: [
                                'Fantasy Sports Platform',
                                'iOS & Android Support',
                                'Real-time Updates',
                                'User Management',
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildProjectCard(
                              title: 'EarnTown Affiliate Network',
                              tech: 'PHP, HTML, CSS, JavaScript, MySQL',
                              description: 'A dashboard from where social media influencers can get web articles to promote with their audience and get paid for the same.',
                              features: [
                                'Affiliate Dashboard',
                                'Content Management',
                                'Payment System',
                                'Analytics Tracking',
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

  Widget _buildProjectCard({
    required String title,
    required String tech,
    required String description,
    required List<String> features,
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
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isDark ? AppTheme.primaryNeon.withOpacity(0.2) : AppTheme.gradientStart.withOpacity(0.1),
                    border: Border.all(
                      color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                    ),
                  ),
                  child: Text(
                    tech,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                      fontFamily: 'Exo2',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppTheme.textPrimary : Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.secondaryNeon : AppTheme.gradientEnd,
                fontFamily: 'Exo2',
              ),
            ),
            const SizedBox(height: 12),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: isDark ? AppTheme.accentNeon : AppTheme.gradientStart,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppTheme.textPrimary : Colors.black87,
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
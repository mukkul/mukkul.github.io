import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/theme_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/neon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          const AnimatedGradientBackground(),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header with theme toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child:                           Text(
                            'AS',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                              fontFamily: 'monospace',
                            ),
                          ),
                      ),
                      IconButton(
                        onPressed: () => themeProvider.toggleTheme(),
                        icon: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Main content
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Name and title
                          Text(
                            'Abhishek Singh',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Title
                          Text(
                            'Senior Software Engineer',
                            style: TextStyle(
                              fontSize: 24,
                              color: isDark ? AppTheme.textSecondary : Colors.grey[700],
                              fontFamily: 'sans-serif',
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Contact info
                          Column(
                            children: [
                              _buildContactItem(
                                icon: Icons.phone,
                                text: '8446059660',
                                onTap: () async {
                                  final Uri phoneUri = Uri(scheme: 'tel', path: '8446059660');
                                  if (await canLaunchUrl(phoneUri)) {
                                    await launchUrl(phoneUri);
                                  }
                                },
                              ),
                              _buildContactItem(
                                icon: Icons.email,
                                text: 'abhishekvsingh1@gmail.com',
                                onTap: () async {
                                  final Uri emailUri = Uri(
                                    scheme: 'mailto',
                                    path: 'abhishekvsingh1@gmail.com',
                                  );
                                  if (await canLaunchUrl(emailUri)) {
                                    await launchUrl(emailUri);
                                  }
                                },
                              ),
                              _buildContactItem(
                                icon: Icons.location_on,
                                text: 'Mumbai',
                                onTap: () {},
                              ),
                              _buildContactItem(
                                icon: Icons.link,
                                text: 'LinkedIn',
                                onTap: () async {
                                  const url = 'https://www.linkedin.com/in/abhishek-vinod-singh/';
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                  }
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 48),
                          
                          // Navigation buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NeonButton(
                                text: 'About',
                                onPressed: () => context.go('/about'),
                              ),
                              NeonButton(
                                text: 'Experience',
                                onPressed: () => context.go('/experience'),
                              ),
                              NeonButton(
                                text: 'Projects',
                                onPressed: () => context.go('/projects'),
                              ),
                              NeonButton(
                                text: 'Contact',
                                onPressed: () => context.go('/contact'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Footer
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Built with Flutter & 🤖',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppTheme.textSecondary : Colors.grey[600],
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

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppTheme.primaryNeon.withValues(alpha: 0.3) : AppTheme.gradientStart.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppTheme.textPrimary : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
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
                        'Contact & Education',
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
                            _buildContactCard(),
                            const SizedBox(height: 24),
                                                         _buildEducationCard(),
                             const SizedBox(height: 24),
                             _buildCreditCard(),
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

  Widget _buildContactCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 24),
            _buildContactItem(
              icon: Icons.phone,
              title: 'Phone',
              value: '8446059660',
              onTap: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: '8446059660');
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                }
              },
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.email,
              title: 'Email',
              value: 'abhishekvsingh1@gmail.com',
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
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.location_on,
              title: 'Location',
              value: 'Mumbai, India',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.link,
              title: 'LinkedIn',
              value: 'LinkedIn Profile',
              onTap: () async {
                const url = 'https://www.linkedin.com/in/abhishekvsingh1/';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Education',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.primaryNeon.withOpacity(0.2) : AppTheme.gradientStart.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                    ),
                  ),
                  child: Icon(
                    Icons.school,
                    color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mumbai University',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.textPrimary : Colors.black87,
                          fontFamily: 'Exo2',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bachelor of Engineering in Information Technology',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? AppTheme.textSecondary : Colors.grey[600],
                          fontFamily: 'Exo2',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppTheme.primaryNeon.withOpacity(0.3) : AppTheme.gradientStart.withOpacity(0.3),
          ),
          color: isDark ? AppTheme.darkSurface : Colors.grey[50],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.primaryNeon.withOpacity(0.2) : AppTheme.gradientStart.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppTheme.textSecondary : Colors.grey[600],
                      fontFamily: 'Exo2',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.textPrimary : Colors.black87,
                      fontFamily: 'Exo2',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? AppTheme.textSecondary : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Development Credit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.primaryNeon.withValues(alpha: 0.2) : AppTheme.gradientStart.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                    ),
                  ),
                  child: Icon(
                    Icons.code,
                    color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-Assisted Development',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.textPrimary : Colors.black87,
                          fontFamily: 'Exo2',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'This portfolio was developed with the assistance of Claude AI, showcasing the power of human-AI collaboration in modern software development.',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? AppTheme.textSecondary : Colors.grey[600],
                          fontFamily: 'Exo2',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
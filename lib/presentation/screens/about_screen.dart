import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/animated_gradient_background.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
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
                        'About Me',
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
                            _buildAboutCard(),
                            const SizedBox(height: 24),
                            _buildSkillsSection(),
                            const SizedBox(height: 24),
                            _buildTechnicalSkillsSection(),
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

  Widget _buildAboutCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Senior Software Engineer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Senior Software Engineer with more than 5 years of experience with strong blend of '
              'technology expertise and business acumen. I have actively contributed to the industry at '
              'FitPhilia Solutions (FitWay), and Lendingkart Technologies. I have also had my fair share of '
              'entrepreneurial journey at EarnTown.com (Affiliate Marketing) & Proxykhel (Fantasy App).',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppTheme.textPrimary : Colors.black87,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skills = [
      'DSA', 'App Development', 'Micro-services',
      'REST API', 'Team Leadership', 'Scrum'
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skills',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: skills.map((skill) => _buildSkillChip(skill)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalSkillsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technical Skills',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 16),
            _buildSkillCategory('Programming Languages', [
              'Dart', 'Java', 'PHP', 'Python', 'Kotlin', 'Javascript'
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('Framework/Libraries', [
              'Flutter', 'SpringBoot', 'React', 'Bloc', 'GetX', 'Robot Framework'
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('Databases', [
              'PostgreSQL', 'MySQL', 'MongoDB', 'Firebase Firestore', 'Cassandra'
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('Project Management', [
              'JIRA', 'Confluence', 'Trello', 'Asana', 'Clickup'
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('CI/CD & Other Technologies', [
              'Docker', 'Kubernetes', 'Terraform', 'Git', 'AWS'
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCategory(String title, List<String> skills) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.secondaryNeon : AppTheme.gradientEnd,
            fontFamily: 'Exo2',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) => _buildSkillChip(skill)).toList(),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.primaryNeon.withOpacity(0.5) : AppTheme.gradientStart.withOpacity(0.5),
        ),
        color: isDark ? AppTheme.darkCard : Colors.grey[100],
      ),
      child: Text(
        skill,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppTheme.textPrimary : Colors.black87,
          fontFamily: 'Exo2',
        ),
      ),
    );
  }
} 
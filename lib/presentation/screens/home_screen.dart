import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/theme_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/neon_button.dart';
import '../widgets/particles/particle_widget.dart';
import '../widgets/scroll_reveal_animation.dart';
import '../../services/resume_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  late AutoScrollController _scrollController;
  final List<GlobalKey> _sectionKeys = [];
  


  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController();
    
    // Initialize section keys
    for (int i = 0; i < 7; i++) {
      _sectionKeys.add(GlobalKey());
    }
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    _scrollController.scrollToIndex(
      index,
      duration: const Duration(milliseconds: 800),
      preferPosition: AutoScrollPosition.begin,
    );
  }

  Future<void> _downloadResume() async {
    await ResumeService.downloadResume();
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
          
          // Particles effect
          const ParticleWidget(),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Navigation header
                _buildNavigationHeader(isDark),
                
                // Scrollable content
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24.0),
                    children: [
                      // Hero Section
                      AutoScrollTag(
                        key: _sectionKeys[0],
                        index: 0,
                        controller: _scrollController,
                        child: _buildHeroSection(isDark),
                      ),
                      const SizedBox(height: 100),
                      
                      // About Section
                      AutoScrollTag(
                        key: _sectionKeys[1],
                        index: 1,
                        controller: _scrollController,
                        child: ScrollRevealAnimation(
                          child: _buildAboutSection(isDark),
                        ),
                      ),
                      const SizedBox(height: 100),
                      
                      // Skills Section
                      AutoScrollTag(
                        key: _sectionKeys[2],
                        index: 2,
                        controller: _scrollController,
                        child: ScrollRevealAnimation(
                          beginOffset: const Offset(50, 0),
                          child: _buildSkillsSection(isDark),
                        ),
                      ),
                      const SizedBox(height: 100),
                      
                      // Technical Skills Section
                      AutoScrollTag(
                        key: _sectionKeys[3],
                        index: 3,
                        controller: _scrollController,
                        child: ScrollRevealAnimation(
                          beginOffset: const Offset(50, 0),
                          child: _buildTechnicalSkillsSection(isDark),
                        ),
                      ),
                      const SizedBox(height: 100),
                      
                      // Experience Preview Section
                      AutoScrollTag(
                        key: _sectionKeys[4],
                        index: 4,
                        controller: _scrollController,
                        child: ScrollRevealAnimation(
                          beginOffset: const Offset(-50, 0),
                          child: _buildExperiencePreviewSection(isDark),
                        ),
                      ),
                      const SizedBox(height: 100),
                      
                      // Projects Preview Section
                      AutoScrollTag(
                        key: _sectionKeys[5],
                        index: 5,
                        controller: _scrollController,
                        child: ScrollRevealAnimation(
                          beginOffset: const Offset(0, 100),
                          child: _buildProjectsPreviewSection(isDark),
                        ),
                      ),
                      const SizedBox(height: 100),
                      
                      // Education Section
                      AutoScrollTag(
                        key: _sectionKeys[6],
                        index: 6,
                        controller: _scrollController,
                        child: ScrollRevealAnimation(
                          beginOffset: const Offset(0, 50),
                          child: _buildEducationSection(isDark),
                        ),
                      ),
                      const SizedBox(height: 100),
                      

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationHeader(bool isDark) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkBg.withOpacity(0.8) : Colors.white.withOpacity(0.8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'AS',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Row(
                children: [
                  _buildNavButton('Home', 0, isDark),
                  _buildNavButton('About', 1, isDark),
                  _buildNavButton('Skills', 2, isDark),
                  _buildNavButton('Technical Skills', 3, isDark),
                  _buildNavButton('Experience', 4, isDark),
                  _buildNavButton('Projects', 5, isDark),
                  _buildNavButton('Education', 6, isDark),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(String text, int index, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () => _scrollToSection(index),
        child: Text(
          text,
          style: TextStyle(
            color: isDark ? AppTheme.textPrimary : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isDark) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated name
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Abhishek Singh',
                      textStyle: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                        fontFamily: 'monospace',
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
                const SizedBox(height: 16),
                
                                          // Animated title
                          AnimatedTextKit(
                            animatedTexts: [
                              FadeAnimatedText(
                                'Senior Software Engineer',
                                textStyle: TextStyle(
                                  fontSize: 24,
                                  color: isDark ? AppTheme.textSecondary : Colors.grey[700],
                                  fontFamily: 'sans-serif',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                              FadeAnimatedText(
                                'Mobile App Developer',
                                textStyle: TextStyle(
                                  fontSize: 24,
                                  color: isDark ? AppTheme.secondaryNeon : AppTheme.gradientEnd,
                                  fontFamily: 'sans-serif',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                              FadeAnimatedText(
                                'Team Leader',
                                textStyle: TextStyle(
                                  fontSize: 24,
                                  color: isDark ? AppTheme.accentNeon : AppTheme.gradientStart,
                                  fontFamily: 'sans-serif',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            ],
                            repeatForever: true,
                          ),
                
                const SizedBox(height: 32),
                
                // Resume download button
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: NeonButton(
                    text: 'Download Resume',
                    onPressed: _downloadResume,
                    width: 200,
                  ),
                ),

                
                const SizedBox(height: 48),
                
                // Contact info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(width: 16),
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
                    const SizedBox(width: 16),
                    _buildContactItem(
                      icon: FontAwesomeIcons.linkedin,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.primaryNeon.withOpacity(0.3) : AppTheme.gradientStart.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Senior Software Engineer with 6+ years of experience delivering scalable fintech, healthtech, and affiliate '
            'platforms. Expertise in Android, Flutter, microservices, REST APIs, and team leadership. '
            'Proven track record at Kotak Securities, Lendingkart and FitPhilia.',
            style: TextStyle(
              fontSize: 18,
              color: isDark ? AppTheme.textPrimary : Colors.black87,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
              ),
              const SizedBox(width: 8),
              Text(
                'Mumbai, India',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? AppTheme.textSecondary : Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(bool isDark) {
    final skills = [
      {'name': 'Flutter', 'level': 0.95, 'icon': Icons.phone_android},
      {'name': 'Android', 'level': 0.90, 'icon': Icons.android},
      {'name': 'Dart', 'level': 0.90, 'icon': Icons.code},
      {'name': 'Java/Kotlin', 'level': 0.85, 'icon': Icons.developer_mode},
      {'name': 'REST APIs', 'level': 0.90, 'icon': Icons.api},
      {'name': 'Microservices', 'level': 0.85, 'icon': Icons.cloud},
      {'name': 'Team Leadership', 'level': 0.90, 'icon': Icons.people},
      {'name': 'DevOps', 'level': 0.80, 'icon': Icons.settings},
    ];

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.secondaryNeon.withOpacity(0.3) : AppTheme.gradientEnd.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills & Technologies',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.secondaryNeon : AppTheme.gradientEnd,
            ),
          ),
          const SizedBox(height: 32),
          ...skills.map((skill) => _buildSkillItem(skill, isDark)).toList(),
        ],
      ),
    );
  }

  Widget _buildSkillItem(Map<String, dynamic> skill, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                skill['icon'],
                color: isDark ? AppTheme.secondaryNeon : AppTheme.gradientEnd,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                skill['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.textPrimary : Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                '${(skill['level'] * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppTheme.textSecondary : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: skill['level'],
            backgroundColor: isDark ? AppTheme.darkSurface : Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? AppTheme.secondaryNeon : AppTheme.gradientEnd,
            ),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildExperiencePreviewSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.accentNeon.withOpacity(0.3) : AppTheme.gradientStart.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Experience',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.accentNeon : AppTheme.gradientStart,
                ),
              ),
              NeonButton(
                text: 'View All',
                onPressed: () => context.go('/experience'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildExperienceItem(
            'Senior Manager',
            'Kotak Securities',
            'Apr 2024 - Present',
            'Led a 6-member team in developing Kotak Neo App. Responsible for Development, Deployment and Performance monitoring. Ensuring seamless experience for 3-4 Lacs daily active users.',
            isDark,
          ),
          const SizedBox(height: 20),
          _buildExperienceItem(
            'Senior Software Engineer',
            'Lendingkart Technologies',
            'Jul 2022 - Apr 2024',
            'Spearheaded Lendingkart Mobile App development with Clean Architecture & MVVM. Built RMS Dashboard using Flutter. Improved test coverage from 45% to 88%.',
            isDark,
          ),
          const SizedBox(height: 20),
          _buildExperienceItem(
            'Software Engineer',
            'FitPhilia Solutions',
            'Jan 2019 - Jul 2022',
            'Led development of Fitway CRM App delivered to 300+ Fitness Center Owners. Integrated third-party SDKs and implemented Material Design Guidelines.',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(String title, String company, String period, String description, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.accentNeon.withOpacity(0.2) : AppTheme.gradientStart.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.textPrimary : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            company,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            period,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.textSecondary : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.textSecondary : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsPreviewSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.primaryNeon.withOpacity(0.3) : AppTheme.gradientStart.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Projects',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                ),
              ),
              NeonButton(
                text: 'View All',
                onPressed: () => context.go('/projects'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildProjectCard(
                  'Kotak Neo App',
                  'Flutter, Android, Microservices',
                  'Led development of Kotak Securities mobile app serving 3-4 Lacs daily active users with seamless trading experience.',
                  isDark,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildProjectCard(
                  'Lendingkart Mobile App',
                  'Flutter, Clean Architecture, MVVM',
                  'Spearheaded development with Clean Architecture principles, MVVM pattern, and Test-Driven Development.',
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildProjectCard(
                  'RMS Dashboard',
                  'Flutter Web/Mobile',
                  'Built comprehensive dashboard for Lendingkart customer representatives to resolve customer issues efficiently.',
                  isDark,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildProjectCard(
                  'Fitway CRM App',
                  'Android, Java/Kotlin, Firebase',
                  'Led development of CRM app delivered to 300+ Fitness Center Owners with third-party integrations.',
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String tech, String description, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.primaryNeon.withOpacity(0.2) : AppTheme.gradientStart.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.textPrimary : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tech,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.textSecondary : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalSkillsSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.primaryNeon.withOpacity(0.3) : AppTheme.gradientStart.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Skills',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkillCategory('Languages', ['Dart', 'Java', 'Kotlin', 'PHP', 'Python', 'JavaScript'], isDark),
                    const SizedBox(height: 24),
                    _buildSkillCategory('Frameworks', ['Flutter', 'SpringBoot', 'React', 'Bloc', 'GetX'], isDark),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkillCategory('Databases', ['PostgreSQL', 'MySQL', 'MongoDB', 'Firebase'], isDark),
                    const SizedBox(height: 24),
                    _buildSkillCategory('DevOps', ['Docker', 'Kubernetes', 'Terraform', 'AWS', 'Git'], isDark),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSkillCategory('Agile Tools', ['JIRA', 'Confluence', 'Trello', 'Asana', 'Clickup'], isDark),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(String title, List<String> skills, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppTheme.secondaryNeon : AppTheme.gradientEnd,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: skills.map((skill) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppTheme.secondaryNeon.withOpacity(0.3) : AppTheme.gradientEnd.withOpacity(0.3),
              ),
            ),
            child: Text(
              skill,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppTheme.textPrimary : Colors.black87,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildEducationSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.accentNeon.withOpacity(0.3) : AppTheme.gradientStart.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.accentNeon : AppTheme.gradientStart,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppTheme.accentNeon.withOpacity(0.2) : AppTheme.gradientStart.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mumbai University',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.textPrimary : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bachelor of Engineering in Information Technology',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
    
    return InkWell(
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
    );
  }
}
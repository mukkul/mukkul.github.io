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
import '../widgets/particles/star_particle_widget.dart';
import '../widgets/scroll_reveal_animation.dart';
import '../../widgets/water_bubble_widget.dart';
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
  
  // New: page controller for full-screen sections
  late PageController _pageController;
  int _currentPage = 0;
  double _pageOffset = 0.0;


  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? _currentPage.toDouble();
      });
    });
    
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
    _pageController.dispose();
    super.dispose();
  }

  void _jumpToPage(int page) {
    setState(() => _currentPage = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _downloadResume() async {
    await ResumeService.downloadResume();
  }



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background with subtle parallax based on page offset
          Transform.translate(
            offset: Offset(0, -20 * (_pageOffset - _currentPage)),
            child: const AnimatedGradientBackground(),
          ),
          
          // Star particles effect with upward movement (inverted rainfall)
          Transform.translate(
            offset: Offset(0, -40 * (_pageOffset - _currentPage)),
            child: const StarParticleWidget(),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Navigation header
                _buildNavigationHeader(isDark),
                
                // Full-screen sections with PageView
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (p) => setState(() => _currentPage = p),
                    children: [
                      _viewportSection(child: _buildHeroSection(isDark), size: size),
                      _viewportSection(child: ScrollRevealAnimation(child: _buildAboutSection(isDark)), size: size),
                      _viewportSection(child: ScrollRevealAnimation(beginOffset: const Offset(50, 0), child: _buildSkillsSection(isDark)), size: size),
                      _viewportSection(child: ScrollRevealAnimation(beginOffset: const Offset(50, 0), child: _buildTechnicalSkillsSection(isDark)), size: size),
                      _viewportSection(child: ScrollRevealAnimation(beginOffset: const Offset(-50, 0), child: _buildExperiencePreviewSection(isDark)), size: size),
                      _viewportSection(child: ScrollRevealAnimation(beginOffset: const Offset(0, 100), child: _buildProjectsPreviewSection(isDark)), size: size),
                      _viewportSection(child: ScrollRevealAnimation(beginOffset: const Offset(0, 50), child: _buildEducationSection(isDark)), size: size),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Water bubble overlay - positioned on top of everything
          const Positioned.fill(
            child: WaterBubbleWidget(),
          ),
        ],
      ),
    );
  }

  Widget _viewportSection({required Widget child, required Size size}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: SizedBox(
        width: size.width,
        height: size.height - 200,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (c, anim) {
              return FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(anim),
                  child: c,
                ),
              );
            },
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationHeader(bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24, 
            vertical: isMobile ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkBg.withOpacity(0.8) : Colors.white.withOpacity(0.8),
          ),
          child: isMobile ? _buildMobileNavigation(isDark) : _buildDesktopNavigation(isDark, isTablet),
        ),
      ),
    );
  }

  Widget _buildMobileNavigation(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'AS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            IconButton(
              onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildNavButton('Home', 0, isDark, isMobile: true),
              _buildNavButton('About', 1, isDark, isMobile: true),
              _buildNavButton('Skills', 2, isDark, isMobile: true),
              _buildNavButton('Tech', 3, isDark, isMobile: true),
              _buildNavButton('Exp', 4, isDark, isMobile: true),
              _buildNavButton('Projects', 5, isDark, isMobile: true),
              _buildNavButton('Edu', 6, isDark, isMobile: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopNavigation(bool isDark, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'AS',
            style: TextStyle(
              fontSize: isTablet ? 28 : 32,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
              fontFamily: 'monospace',
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildNavButton('Home', 0, isDark),
                _buildNavButton('About', 1, isDark),
                _buildNavButton('Skills', 2, isDark),
                _buildNavButton(isTablet ? 'Tech Skills' : 'Technical Skills', 3, isDark),
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
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(String text, int index, bool isDark, {bool isMobile = false}) {
    final bool isActive = _currentPage == index;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
      child: TextButton(
        onPressed: () => _jumpToPage(index),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: isDark ? AppTheme.textPrimary : Colors.black,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            shadows: isActive
                ? [
                    Shadow(
                      color: AppTheme.primaryNeon.withOpacity(0.7),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    return SizedBox(
      height: MediaQuery.of(context).size.height - (isMobile ? 150 : 200),
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
                        fontSize: isMobile ? 32 : (isTablet ? 40 : 48),
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
                        fontFamily: 'monospace',
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
                SizedBox(height: isMobile ? 12 : 16),
                
                // Animated title
                AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      'Senior Software Engineer',
                      textStyle: TextStyle(
                        fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
                        color: isDark ? AppTheme.textSecondary : Colors.grey[700],
                        fontFamily: 'sans-serif',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                    FadeAnimatedText(
                      'Mobile App Developer',
                      textStyle: TextStyle(
                        fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
                        color: isDark ? AppTheme.secondaryNeon : AppTheme.gradientEnd,
                        fontFamily: 'sans-serif',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                    FadeAnimatedText(
                      'Team Leader',
                      textStyle: TextStyle(
                        fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
                        color: isDark ? AppTheme.accentNeon : AppTheme.gradientStart,
                        fontFamily: 'sans-serif',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  ],
                  repeatForever: true,
                ),
                
                SizedBox(height: isMobile ? 24 : 32),
                
                // Resume download button
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: NeonButton(
                    text: 'Download Resume',
                    onPressed: _downloadResume,
                    width: isMobile ? 180 : 200,
                  ),
                ),

                SizedBox(height: isMobile ? 32 : 48),
                
                // Contact info
                isMobile ? _buildMobileContactInfo(isDark) : _buildDesktopContactInfo(isDark),
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
    return _InteractiveProjectCard(
      title: title,
      tech: tech,
      description: description,
      isDark: isDark,
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



  Widget _buildMobileContactInfo(bool isDark) {
    return Column(
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
        const SizedBox(height: 12),
        _buildContactItem(
          icon: Icons.email,
          text: 'Email',
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
        const SizedBox(height: 12),
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
    );
  }

  Widget _buildDesktopContactInfo(bool isDark) {
    return Row(
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

class _InteractiveProjectCard extends StatefulWidget {
  final String title;
  final String tech;
  final String description;
  final bool isDark;

  const _InteractiveProjectCard({
    required this.title,
    required this.tech,
    required this.description,
    required this.isDark,
  });

  @override
  State<_InteractiveProjectCard> createState() => _InteractiveProjectCardState();
}

class _InteractiveProjectCardState extends State<_InteractiveProjectCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isDark ? AppTheme.primaryNeon : AppTheme.gradientStart;
    final surface = widget.isDark ? AppTheme.darkSurface : Colors.grey[50]!;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -6 * _anim.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor.withOpacity(0.2 + 0.3 * _anim.value),
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: borderColor.withOpacity(0.35),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Shimmering border overlay
                  if (_hovered)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: 0.8,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.02),
                                  borderColor.withOpacity(0.08),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? AppTheme.textPrimary : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.tech,
                        style: TextStyle(
                          fontSize: 14,
                          color: borderColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.isDark ? AppTheme.textSecondary : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
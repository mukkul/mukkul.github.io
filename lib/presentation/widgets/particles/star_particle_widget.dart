import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';

class StarParticleWidget extends StatefulWidget {
  const StarParticleWidget({super.key});

  @override
  State<StarParticleWidget> createState() => _StarParticleWidgetState();
}

class _StarParticleWidgetState extends State<StarParticleWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<StarParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Initialize star particles
    _initializeParticles();
  }

  void _initializeParticles() {
    _particles.clear();
    for (int i = 0; i < 80; i++) {
      _particles.add(StarParticle(
        x: _random.nextDouble() * 2000, // Wider range for better coverage
        y: _random.nextDouble() * 2000, // Start from various heights
        size: _random.nextDouble() * 4 + 1, // Size between 1-5
        speed: _random.nextDouble() * 3 + 1, // Speed between 1-4
        twinkleSpeed: _random.nextDouble() * 0.05 + 0.02, // Twinkle speed
        opacity: _random.nextDouble() * 0.8 + 0.2, // Opacity between 0.2-1.0
        isDark: true, // Will be updated in build method
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Update particle theme
    for (var particle in _particles) {
      particle.isDark = isDark;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarParticlePainter(
            particles: _particles,
            animation: _controller.value,
            screenSize: MediaQuery.of(context).size,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class StarParticle {
  double x;
  double y;
  final double size;
  final double speed;
  final double twinkleSpeed;
  double opacity;
  double twinklePhase = 0;
  bool isDark;

  StarParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.twinkleSpeed,
    required this.opacity,
    required this.isDark,
  });

  void update(double deltaTime, Size screenSize) {
    // Move upward (inverted rainfall effect)
    y -= speed * deltaTime * 60; // Scale for 60 FPS
    
    // Add slight horizontal drift for more natural movement
    x += (math.sin(y * 0.01) * 0.5) * deltaTime * 60;
    
    // Update twinkle phase
    twinklePhase += twinkleSpeed * deltaTime * 60;
    
    // Reset position when particle goes off screen
    if (y < -50) {
      y = screenSize.height + 50;
      x = math.Random().nextDouble() * screenSize.width;
    }
    
    // Wrap horizontally
    if (x < -50) x = screenSize.width + 50;
    if (x > screenSize.width + 50) x = -50;
  }

  double get currentOpacity {
    return opacity * (0.5 + 0.5 * math.sin(twinklePhase));
  }
}

class StarParticlePainter extends CustomPainter {
  final List<StarParticle> particles;
  final double animation;
  final Size screenSize;

  StarParticlePainter({
    required this.particles,
    required this.animation,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Update particles
    for (var particle in particles) {
      particle.update(0.016, screenSize); // 60 FPS
    }

    // Draw particles
    for (var particle in particles) {
      final currentOpacity = particle.currentOpacity;
      
      // Create star shape
      _drawStar(
        canvas,
        Offset(particle.x, particle.y),
        particle.size,
        particle.isDark ? AppTheme.primaryNeon : AppTheme.gradientStart,
        currentOpacity,
      );
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Color color, double opacity) {
    final paint = Paint()
      ..color = color.withOpacity(opacity * 0.8)
      ..style = PaintingStyle.fill;

    final outerRadius = size;
    final innerRadius = size * 0.4;
    final numPoints = 5;

    final path = Path();
    
    for (int i = 0; i < numPoints * 2; i++) {
      final angle = (i * math.pi) / numPoints;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);

    // Add a subtle glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(opacity * 0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawPath(path, glowPaint);

    // Add a bright center dot
    final centerPaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, size * 0.2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

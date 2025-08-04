import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';
import '../../../core/theme/app_theme.dart';

class ParticleWidget extends StatefulWidget {
  const ParticleWidget({super.key});

  @override
  State<ParticleWidget> createState() => _ParticleWidgetState();
}

class _ParticleWidgetState extends State<ParticleWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle(
        x: _random.nextDouble() * 1000,
        y: _random.nextDouble() * 1000,
        size: _random.nextDouble() * 3 + 1,
        speed: _random.nextDouble() * 2 + 0.5,
        angle: _random.nextDouble() * 2 * math.pi,
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            animation: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  double angle;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
  });

  void update(double deltaTime) {
    x += math.cos(angle) * speed * deltaTime;
    y += math.sin(angle) * speed * deltaTime;
    
    // Wrap around screen
    if (x < 0) x = 1000;
    if (x > 1000) x = 0;
    if (y < 0) y = 1000;
    if (y > 1000) y = 0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticlePainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Update particles
    for (var particle in particles) {
      particle.update(0.016); // 60 FPS
    }

    // Draw particles
    for (var particle in particles) {
      final paint = Paint()
        ..color = AppTheme.primaryNeon.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      final x = (particle.x / 1000) * size.width;
      final y = (particle.y / 1000) * size.height;

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );

      // Draw connecting lines between nearby particles
      for (var otherParticle in particles) {
        if (particle != otherParticle) {
          final distance = math.sqrt(
            math.pow(particle.x - otherParticle.x, 2) +
            math.pow(particle.y - otherParticle.y, 2),
          );

          if (distance < 100) {
            final linePaint = Paint()
              ..color = AppTheme.secondaryNeon.withOpacity(0.1)
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke;

            final x1 = (particle.x / 1000) * size.width;
            final y1 = (particle.y / 1000) * size.height;
            final x2 = (otherParticle.x / 1000) * size.width;
            final y2 = (otherParticle.y / 1000) * size.height;

            canvas.drawLine(
              Offset(x1, y1),
              Offset(x2, y2),
              linePaint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 
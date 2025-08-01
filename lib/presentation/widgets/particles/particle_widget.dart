import 'package:flutter/material.dart';
import 'dart:math' as math;
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
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Create particles
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 3 + 1,
        speed: _random.nextDouble() * 0.5 + 0.1,
        opacity: _random.nextDouble() * 0.5 + 0.2,
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
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
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
    for (final particle in particles) {
      // Update particle position
      particle.y -= particle.speed * 0.01;
      if (particle.y < -0.1) {
        particle.y = 1.1;
        particle.x = math.Random().nextDouble();
      }

      // Draw particle
      final paint = Paint()
        ..color = AppTheme.primaryNeon.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final y = particle.y * size.height;

      // Draw glow effect
      final glowPaint = Paint()
        ..color = AppTheme.primaryNeon.withOpacity(particle.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
        Offset(x, y),
        particle.size * 2,
        glowPaint,
      );

      // Draw main particle
      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );

      // Draw connecting lines between nearby particles
      for (final otherParticle in particles) {
        if (particle != otherParticle) {
          final distance = math.sqrt(
            math.pow(particle.x - otherParticle.x, 2) +
            math.pow(particle.y - otherParticle.y, 2),
          );

          if (distance < 0.1) {
            final linePaint = Paint()
              ..color = AppTheme.secondaryNeon.withOpacity(0.1)
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke;

            canvas.drawLine(
              Offset(x, y),
              Offset(
                otherParticle.x * size.width,
                otherParticle.y * size.height,
              ),
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
import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterBubbleWidget extends StatefulWidget {
  const WaterBubbleWidget({super.key});

  @override
  State<WaterBubbleWidget> createState() => _WaterBubbleWidgetState();
}

class _WaterBubbleWidgetState extends State<WaterBubbleWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _radiusControllers;
  late List<AnimationController> _positionControllers;
  late List<AnimationController> _pulseControllers;
  
  late List<Animation<double>> _radiusAnimations;
  late List<Animation<Offset>> _positionAnimations;
  late List<Animation<double>> _pulseAnimations;
  
  late List<Offset> _currentPositions;
  late List<Offset> _targetPositions;
  late List<double> _baseRadii;
  
  int _bubbleCount = 5; // Number of bubbles
  double _minRadius = 30.0;
  double _maxRadius = 100.0;

  @override
  void initState() {
    super.initState();
    
    // Initialize lists
    _currentPositions = List.generate(_bubbleCount, (index) => const Offset(200, 200));
    _targetPositions = List.generate(_bubbleCount, (index) => const Offset(200, 200));
    _baseRadii = List.generate(_bubbleCount, (index) => 
      _minRadius + (index * (_maxRadius - _minRadius) / (_bubbleCount - 1)));
    
    // Initialize animation controllers
    _radiusControllers = List.generate(_bubbleCount, (index) => 
      AnimationController(
        duration: Duration(seconds: 1 + (index * 2)), // Different durations for each bubble
        vsync: this,
      ));
    
    _positionControllers = List.generate(_bubbleCount, (index) => 
      AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 1000)), // Different movement speeds
        vsync: this,
      ));
    
    _pulseControllers = List.generate(_bubbleCount, (index) => 
      AnimationController(
        duration: Duration(milliseconds: 3000 + (index * 500)), // Different pulse speeds
        vsync: this,
      ));
    
    // Initialize animations
    _radiusAnimations = List.generate(_bubbleCount, (index) => 
      Tween<double>(
        begin: _baseRadii[index] * 0.5,
        end: _baseRadii[index] * 1.2,
      ).animate(CurvedAnimation(
        parent: _radiusControllers[index],
        curve: Curves.easeInOut,
      )));
    
    _positionAnimations = List.generate(_bubbleCount, (index) => 
      Tween<Offset>(
        begin: _currentPositions[index],
        end: _targetPositions[index],
      ).animate(CurvedAnimation(
        parent: _positionControllers[index],
        curve: Curves.easeInOut,
      )));
    
    _pulseAnimations = List.generate(_bubbleCount, (index) => 
      Tween<double>(
        begin: 0.8,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: _pulseControllers[index],
        curve: Curves.easeInOut,
      )));
    
    // Start animations for all bubbles
    for (int i = 0; i < _bubbleCount; i++) {
      _startRadiusAnimation(i);
      _startPositionAnimation(i);
      _startPulseAnimation(i);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize positions randomly now that context is available
    final screenSize = MediaQuery.of(context).size;
    final random = math.Random();
    
    // Adjust bubble count and size based on screen size
    final screenWidth = screenSize.width;
    if (screenWidth < 768) {
      // Mobile
      _bubbleCount = 3;
      _minRadius = 20.0;
      _maxRadius = 60.0;
    } else if (screenWidth < 1024) {
      // Tablet
      _bubbleCount = 4;
      _minRadius = 25.0;
      _maxRadius = 80.0;
    } else {
      // Desktop
      _bubbleCount = 5;
      _minRadius = 30.0;
      _maxRadius = 100.0;
    }
    
    // Reinitialize if bubble count changed
    if (_currentPositions.length != _bubbleCount) {
      _initializeBubbles();
    }
    
    for (int i = 0; i < _bubbleCount; i++) {
      _currentPositions[i] = Offset(
        random.nextDouble() * (screenSize.width - 200) + 100,
        random.nextDouble() * (screenSize.height - 200) + 100,
      );
      _targetPositions[i] = _currentPositions[i];
    }
  }

  void _startRadiusAnimation(int index) {
    _radiusControllers[index].forward().then((_) {
      _radiusControllers[index].reverse().then((_) {
        if (mounted) {
          _startRadiusAnimation(index); // Loop infinitely
        }
      });
    });
  }

  void _startPositionAnimation(int index) {
    _generateNewTargetPosition(index);
    _positionControllers[index].reset();
    _positionControllers[index].forward().then((_) {
      _currentPositions[index] = _targetPositions[index];
      print('Bubble $index moved to: ${_currentPositions[index]}'); // Debug print
      // Add a small delay before starting the next animation
      Future.delayed(Duration(milliseconds: 500 + (index * 200)), () {
        if (mounted) {
          _startPositionAnimation(index); // Loop infinitely
        }
      });
    });
  }

  void _startPulseAnimation(int index) {
    _pulseControllers[index].repeat(reverse: true);
  }

  void _initializeBubbles() {
    // Dispose existing controllers
    for (int i = 0; i < _radiusControllers.length; i++) {
      _radiusControllers[i].dispose();
      _positionControllers[i].dispose();
      _pulseControllers[i].dispose();
    }
    
    // Reinitialize lists
    _currentPositions = List.generate(_bubbleCount, (index) => const Offset(200, 200));
    _targetPositions = List.generate(_bubbleCount, (index) => const Offset(200, 200));
    _baseRadii = List.generate(_bubbleCount, (index) => 
      _minRadius + (index * (_maxRadius - _minRadius) / (_bubbleCount - 1)));
    
    // Reinitialize animation controllers
    _radiusControllers = List.generate(_bubbleCount, (index) => 
      AnimationController(
        duration: Duration(seconds: 1 + (index * 2)),
        vsync: this,
      ));
    
    _positionControllers = List.generate(_bubbleCount, (index) => 
      AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 1000)),
        vsync: this,
      ));
    
    _pulseControllers = List.generate(_bubbleCount, (index) => 
      AnimationController(
        duration: Duration(milliseconds: 3000 + (index * 500)),
        vsync: this,
      ));
    
    // Reinitialize animations
    _radiusAnimations = List.generate(_bubbleCount, (index) => 
      Tween<double>(
        begin: _baseRadii[index] * 0.5,
        end: _baseRadii[index] * 1.5,
      ).animate(CurvedAnimation(
        parent: _radiusControllers[index],
        curve: Curves.easeInOut,
      )));
    
    _positionAnimations = List.generate(_bubbleCount, (index) => 
      Tween<Offset>(
        begin: _currentPositions[index],
        end: _targetPositions[index],
      ).animate(CurvedAnimation(
        parent: _positionControllers[index],
        curve: Curves.easeInOut,
      )));
    
    _pulseAnimations = List.generate(_bubbleCount, (index) => 
      Tween<double>(
        begin: 0.8,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: _pulseControllers[index],
        curve: Curves.easeInOut,
      )));
    
    // Restart animations
    for (int i = 0; i < _bubbleCount; i++) {
      _startRadiusAnimation(i);
      _startPositionAnimation(i);
      _startPulseAnimation(i);
    }
  }

  void _generateNewTargetPosition(int index) {
    try {
      final screenSize = MediaQuery.of(context).size;
      final random = math.Random();
      
      // Generate new target position avoiding edges
      _targetPositions[index] = Offset(
        random.nextDouble() * (screenSize.width - 300) + 150,
        random.nextDouble() * (screenSize.height - 300) + 150,
      );
    } catch (e) {
      // Fallback to a random position if MediaQuery is not available
      final random = math.Random();
      _targetPositions[index] = Offset(
        random.nextDouble() * 600 + 200,
        random.nextDouble() * 400 + 200,
      );
    }
    
    // Update position animation
    _positionAnimations[index] = Tween<Offset>(
      begin: _currentPositions[index],
      end: _targetPositions[index],
    ).animate(CurvedAnimation(
      parent: _positionControllers[index],
      curve: Curves.easeInOut,
    ));
  }


  @override
  void dispose() {
    for (int i = 0; i < _bubbleCount; i++) {
      _radiusControllers[i].dispose();
      _positionControllers[i].dispose();
      _pulseControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(_bubbleCount, (index) {
          return AnimatedBuilder(
            animation: Listenable.merge([
              _radiusAnimations[index], 
              _positionAnimations[index], 
              _pulseAnimations[index]
            ]),
            builder: (context, child) {
              final currentRadius = _radiusAnimations[index].value;
              final currentPosition = _positionAnimations[index].value;
              final pulseScale = _pulseAnimations[index].value;
              
              return Transform.translate(
                offset: Offset(
                  currentPosition.dx - currentRadius,
                  currentPosition.dy - currentRadius,
                ),
                child: Transform.scale(
                  scale: pulseScale,
                  child: CustomPaint(
                    size: Size(currentRadius * 2, currentRadius * 2),
                    painter: WaterBubblePainter(
                      radius: currentRadius,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                      opacity: 0.3 + (index * 0.1), // Different opacity for each bubble
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class WaterBubblePainter extends CustomPainter {
  final double radius;
  final bool isDark;
  final double opacity;

  WaterBubblePainter({
    required this.radius,
    required this.isDark,
    this.opacity = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Create gradient for water bubble effect
    final gradient = RadialGradient(
      colors: [
        (isDark ? const Color(0xFF00FFFF) : const Color(0xFF1E3A8A))
            .withOpacity(0.15 * opacity),
        (isDark ? const Color(0xFF00FFFF) : const Color(0xFF1E3A8A))
            .withOpacity(0.08 * opacity),
        (isDark ? const Color(0xFF00FFFF) : const Color(0xFF1E3A8A))
            .withOpacity(0.03 * opacity),
        Colors.transparent,
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );
    
    // Main bubble circle
    final bubblePaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, bubblePaint);
    
    // Add subtle border
    final borderPaint = Paint()
      ..color = (isDark ? const Color(0xFF00FFFF) : const Color(0xFF1E3A8A))
          .withOpacity(0.2 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawCircle(center, radius, borderPaint);
    
    // Add inner highlight for water effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.1 * opacity)
      ..style = PaintingStyle.fill;
    
    final highlightRadius = radius * 0.3;
    final highlightCenter = Offset(
      center.dx - radius * 0.2,
      center.dy - radius * 0.2,
    );
    
    canvas.drawCircle(highlightCenter, highlightRadius, highlightPaint);
    
    // Add subtle shimmer effect
    final shimmerPaint = Paint()
      ..color = Colors.white.withOpacity(0.05 * opacity)
      ..style = PaintingStyle.fill;
    
    final shimmerPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(center.dx - radius * 0.1, center.dy - radius * 0.1),
        radius: radius * 0.1,
      ));
    
    canvas.drawPath(shimmerPath, shimmerPaint);
  }

  @override
  bool shouldRepaint(WaterBubblePainter oldDelegate) {
    return oldDelegate.radius != radius || 
           oldDelegate.isDark != isDark || 
           oldDelegate.opacity != opacity;
  }
}

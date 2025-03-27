import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A widget that displays a tree with animated features
///
/// The tree's appearance changes based on the growth stage and points
class TreeWidget extends StatefulWidget {
  /// The current growth stage of the tree
  final String stage;

  /// The current growth points (0-100)
  final int growthPoints;

  /// Whether to show sparkle effects around the tree
  final bool showSparkles;

  /// Creates a TreeWidget
  const TreeWidget({
    super.key,
    required this.stage,
    required this.growthPoints,
    this.showSparkles = false,
  });

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget> with TickerProviderStateMixin {
  late AnimationController _swayController;
  late AnimationController _sparkleController;
  late Animation<double> _swayAnimation;

  final List<Offset> _sparklePositions = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _swayController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _swayAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _swayController, curve: Curves.easeInOut),
    );

    _generateSparkles();

    if (widget.showSparkles) {
      _sparkleController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TreeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showSparkles != oldWidget.showSparkles) {
      if (widget.showSparkles) {
        _sparkleController.repeat(reverse: true);
      } else {
        _sparkleController.stop();
      }
    }
  }

  void _generateSparkles() {
    _sparklePositions.clear();
    for (int i = 0; i < 10; i++) {
      _sparklePositions.add(
        Offset(
          _random.nextDouble() * 200 - 100,
          _random.nextDouble() * 300 - 150,
        ),
      );
    }
  }

  @override
  void dispose() {
    _swayController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated Sky Background
        Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue[200]!, Colors.lightBlue[100]!],
            ),
          ),
          child: CustomPaint(painter: CloudPainter()),
        ),

        // Animated Tree
        AnimatedBuilder(
          animation: _swayAnimation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.rotationZ(_swayAnimation.value),
              child: _buildTree(),
            );
          },
        ),

        // Ground
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green[700]!, Colors.green[900]!],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(1000),
                topRight: Radius.circular(1000),
              ),
            ),
          ),
        ),

        // Sparkles
        if (widget.showSparkles) ..._buildSparkles(),
      ],
    );
  }

  List<Widget> _buildSparkles() {
    return List.generate(_sparklePositions.length, (index) {
      return AnimatedBuilder(
        animation: _sparkleController,
        builder: (context, child) {
          return Positioned(
            left: _sparklePositions[index].dx + 100,
            top: _sparklePositions[index].dy + 200,
            child: FadeTransition(
              opacity: _sparkleController,
              child: const Icon(Icons.star, color: Colors.yellow, size: 20),
            ),
          );
        },
      );
    });
  }

  Widget _buildTree() {
    final TreeTheme theme = _getTreeTheme();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tree Crown
        _buildTreeCrown(theme),

        // Tree Trunk
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: theme.trunkWidth,
          height: theme.trunkHeight,
          decoration: BoxDecoration(
            color: theme.trunkColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildTreeCrown(TreeTheme theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ...List.generate(
          widget.growthPoints ~/ 10,
          (index) => Transform.translate(
            offset: Offset(math.cos(index * math.pi / 6) * 20, -index * 15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: theme.leafSize,
              height: theme.leafSize,
              decoration: BoxDecoration(
                color: theme.leafColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        ...theme.specialFeatures,
      ],
    );
  }

  TreeTheme _getTreeTheme() {
    switch (widget.stage) {
      case 'Grand Tree':
        return TreeTheme(
          trunkHeight: 250,
          trunkWidth: 30,
          leafSize: 70,
          trunkColor: Colors.brown[700]!,
          leafColor: Colors.green[700]!,
          specialFeatures: [
            Positioned(
              top: -20,
              child: Icon(
                Icons.brightness_7,
                color: Colors.amber[600],
                size: 40,
              ),
            ),
          ],
        );
      case 'Mature Tree':
        return TreeTheme(
          trunkHeight: 200,
          trunkWidth: 25,
          leafSize: 60,
          trunkColor: Colors.brown[600]!,
          leafColor: Colors.green[600]!,
          specialFeatures: [
            Positioned(
              bottom: 50,
              right: 30,
              child: Icon(
                Icons.auto_awesome,
                color: Colors.amber[300],
                size: 24,
              ),
            ),
          ],
        );
      case 'Young Tree':
        return TreeTheme(
          trunkHeight: 150,
          trunkWidth: 20,
          leafSize: 50,
          trunkColor: Colors.brown[500]!,
          leafColor: Colors.green[500]!,
          specialFeatures: [],
        );
      case 'Sapling':
        return TreeTheme(
          trunkHeight: 100,
          trunkWidth: 15,
          leafSize: 40,
          trunkColor: Colors.brown[400]!,
          leafColor: Colors.green[400]!,
          specialFeatures: [],
        );
      case 'Seedling':
      default:
        return TreeTheme(
          trunkHeight: 50,
          trunkWidth: 10,
          leafSize: 30,
          trunkColor: Colors.brown[300]!,
          leafColor: Colors.green[300]!,
          specialFeatures: [],
        );
    }
  }
}

/// Theme configuration for tree appearance
class TreeTheme {
  /// Height of the tree trunk
  final double trunkHeight;

  /// Width of the tree trunk
  final double trunkWidth;

  /// Size of each leaf
  final double leafSize;

  /// Color of the tree trunk
  final Color trunkColor;

  /// Color of the tree leaves
  final Color leafColor;

  /// Special decorative elements based on tree stage
  final List<Widget> specialFeatures;

  /// Creates a TreeTheme with the specified properties
  const TreeTheme({
    required this.trunkHeight,
    required this.trunkWidth,
    required this.leafSize,
    required this.trunkColor,
    required this.leafColor,
    this.specialFeatures = const [],
  });
}

/// CustomPainter for drawing clouds in the sky background
class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.7)
          ..style = PaintingStyle.fill;

    void drawCloud(double x, double y, double scale) {
      canvas.drawCircle(Offset(x, y), 20 * scale, paint);
      canvas.drawCircle(
        Offset(x + 15 * scale, y - 10 * scale),
        15 * scale,
        paint,
      );
      canvas.drawCircle(Offset(x + 30 * scale, y), 20 * scale, paint);
    }

    drawCloud(size.width * 0.2, size.height * 0.2, 1);
    drawCloud(size.width * 0.6, size.height * 0.3, 1.2);
    drawCloud(size.width * 0.8, size.height * 0.1, 0.8);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

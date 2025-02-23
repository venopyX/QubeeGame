import 'package:flutter/material.dart';
import 'dart:math' as math;

class TreeWidget extends StatefulWidget {
  final String stage;
  final int growthPoints;
  final bool showSparkles;

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

        if (widget.showSparkles)
          ...List.generate(_sparklePositions.length, (index) {
            return AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                return Positioned(
                  left: _sparklePositions[index].dx + 100,
                  top: _sparklePositions[index].dy + 200,
                  child: FadeTransition(
                    opacity: _sparkleController,
                    child: const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                  ),
                );
              },
            );
          }),
      ],
    );
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
      children: List.generate(
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
    );
  }

  TreeTheme _getTreeTheme() {
    switch (widget.stage) {
      case 'Seedling':
        return TreeTheme(
          trunkHeight: 50,
          trunkWidth: 10,
          leafSize: 30,
          trunkColor: Colors.brown[300]!,
          leafColor: Colors.green[300]!,
        );
      case 'Sapling':
        return TreeTheme(
          trunkHeight: 100,
          trunkWidth: 15,
          leafSize: 40,
          trunkColor: Colors.brown[400]!,
          leafColor: Colors.green[400]!,
        );
      case 'Young Tree':
        return TreeTheme(
          trunkHeight: 150,
          trunkWidth: 20,
          leafSize: 50,
          trunkColor: Colors.brown[500]!,
          leafColor: Colors.green[500]!,
        );
      case 'Mature Tree':
        return TreeTheme(
          trunkHeight: 200,
          trunkWidth: 25,
          leafSize: 60,
          trunkColor: Colors.brown[600]!,
          leafColor: Colors.green[600]!,
        );
      default: // Grand Tree
        return TreeTheme(
          trunkHeight: 250,
          trunkWidth: 30,
          leafSize: 70,
          trunkColor: Colors.brown[700]!,
          leafColor: Colors.green[700]!,
        );
    }
  }
}

class TreeTheme {
  final double trunkHeight;
  final double trunkWidth;
  final double leafSize;
  final Color trunkColor;
  final Color leafColor;

  TreeTheme({
    required this.trunkHeight,
    required this.trunkWidth,
    required this.leafSize,
    required this.trunkColor,
    required this.leafColor,
  });
}

class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.7)
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

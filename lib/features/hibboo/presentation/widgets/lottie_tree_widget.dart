import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:collection/collection.dart';

class LottieTreeWidget extends StatefulWidget {
  final String stage;
  final int growthPoints;
  final bool showSparkles;

  const LottieTreeWidget({
    super.key,
    required this.stage,
    required this.growthPoints,
    this.showSparkles = false,
  });

  @override
  State<LottieTreeWidget> createState() => _LottieTreeWidgetState();
}

class _LottieTreeWidgetState extends State<LottieTreeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.showSparkles) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(LottieTreeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showSparkles != oldWidget.showSparkles) {
      widget.showSparkles
          ? _animationController.repeat()
          : _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<LottieComposition?> _customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(
      bytes,
      filePicker: (files) {
        return files.firstWhereOrNull(
          (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background gradient
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
        ),

        // Ground area
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

        // Main tree animation
        Lottie.asset(
          _getTreeAnimationPath(),
          width: 300,
          height: 300,
          fit: BoxFit.contain,
          animate: true,
          decoder: _customDecoder,
        ),

        // Growth indicator
        Positioned(bottom: 100, child: _buildGrowthIndicator()),
      ],
    );
  }

  Widget _buildGrowthIndicator() {
    return Container(
      width: 200,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widget.growthPoints / 100,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[300]!, Colors.green[700]!],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.5),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTreeAnimationPath() {
    switch (widget.stage) {
      case 'Seedling':
        return 'assets/animations/guy-gardening.lottie';
      case 'Sapling':
        return 'assets/animations/guy-gardening.lottie';
      case 'Young Tree':
        return 'assets/animations/guy-gardening.lottie';
      case 'Mature Tree':
        return 'assets/animations/guy-gardening.lottie';
      case 'Grand Tree':
        return 'assets/animations/guy-gardening.lottie';
      default:
        return 'assets/animations/guy-gardening.lottie';
    }
  }
}

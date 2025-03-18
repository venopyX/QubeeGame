import 'package:flutter/material.dart';
import 'dart:math';
import '../../domain/entities/qubee.dart';

class LetterTracingWidget extends StatefulWidget {
  final Qubee letter;
  final ValueChanged<double> onAccuracyChanged;
  final VoidCallback onCompleted;

  const LetterTracingWidget({
    required this.letter,
    required this.onAccuracyChanged,
    required this.onCompleted,
    super.key,
  });

  @override
  State<LetterTracingWidget> createState() => _LetterTracingWidgetState();
}

class _LetterTracingWidgetState extends State<LetterTracingWidget> with SingleTickerProviderStateMixin {
  final List<Offset> _userPoints = [];
  final List<Offset> _guidePoints = [];
  final List<List<Offset>> _userStrokes = [];
  List<Offset> _currentStroke = [];
  bool _isTracing = false;
  double _progress = 0.0;
  double _accuracy = 0.0;
  double _pathCoverage = 0.0;
  bool _canComplete = false;
  bool _showGuide = true;
  int _currentSegment = 0;
  
  // Store the letter ID to detect changes
  late int _currentLetterId;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  // Path evaluation parameters
  static const double _proximityThreshold = 20.0;
  static const double _completionThreshold = 0.70; 
  static const double _pathCoverageMinimum = 0.85;
  static const double _penaltyForOffPath = 0.05;
  
  @override
  void initState() {
    super.initState();
    
    _currentLetterId = widget.letter.id;
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(_pulseController);
  }
  
  @override
  void didUpdateWidget(LetterTracingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if the letter has changed and reset if needed
    if (oldWidget.letter.id != widget.letter.id) {
      _resetForNewLetter();
    }
  }
  
  void _resetForNewLetter() {
    // Store the new letter ID
    _currentLetterId = widget.letter.id;
    
    // Reset all tracing state
    _userPoints.clear();
    _userStrokes.clear();
    _currentStroke = [];
    _guidePoints.clear(); // Important! Clear guide points so they'll be recalculated
    _progress = 0.0;
    _accuracy = 0.0;
    _pathCoverage = 0.0;
    _canComplete = false;
    _currentSegment = 0;
    
    // Force a rebuild
    if (mounted) {
      setState(() {});
    }
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _updateGuidePointsWithSize(Size size) {
    _guidePoints.clear();
    for (var point in widget.letter.tracingPoints) {
      _guidePoints.add(Offset(
        point['x']! * size.width,
        point['y']! * size.height,
      ));
    }
  }
  
  // Rest of the implementation remains the same...
  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _isTracing = true;
      _currentStroke = [details.localPosition];
      _userPoints.add(details.localPosition);
      _updateProgress();
    });
  }
  
  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isTracing) {
      setState(() {
        _currentStroke.add(details.localPosition);
        _userPoints.add(details.localPosition);
        _updateProgress();
      });
    }
  }
  
  void _handlePanEnd(DragEndDetails details) {
    if (_isTracing && _currentStroke.isNotEmpty) {
      setState(() {
        _userStrokes.add(List.from(_currentStroke));
        _currentStroke = [];
        _isTracing = false;
        _updateProgress();
      });
    }
  }
  
  void _updateProgress() {
    if (_guidePoints.isEmpty) return;
    
    // Calculate how much of the path has been traced
    final List<bool> segmentsCovered = _calculateSegmentsCovered();
    _pathCoverage = segmentsCovered.where((covered) => covered).length / 
                              segmentsCovered.length;
    
    // Calculate how many of the user's points are near the path (accuracy)
    int pointsOnPath = 0;
    int totalUserPoints = _userPoints.length;
    
    for (var point in _userPoints) {
      bool isNearAnySegment = false;
      for (int i = 0; i < _guidePoints.length - 1; i++) {
        double distance = _distanceToLineSegment(
          point, 
          _guidePoints[i], 
          _guidePoints[i + 1]
        );
        
        if (distance < _proximityThreshold) {
          isNearAnySegment = true;
          break;
        }
      }
      
      if (isNearAnySegment) {
        pointsOnPath++;
      }
    }
    
    // Calculate accuracy - percentage of points that are on the path
    _accuracy = totalUserPoints > 0 ? pointsOnPath / totalUserPoints : 0.0;
    
    // Apply penalties for inaccurate tracing
    double offPathPenalty = (1.0 - _accuracy) * _penaltyForOffPath;
    
    // Calculate final progress
    _progress = (_pathCoverage * 0.7) + (_accuracy * 0.3) - offPathPenalty;
    _progress = _progress.clamp(0.0, 1.0);
    
    // Update current segment the user is tracing
    _updateCurrentSegment();
    
    // Notify parent about accuracy changes
    widget.onAccuracyChanged(_accuracy);
    
    // Check if tracing is complete enough - MUST meet both path coverage and overall progress thresholds
    _canComplete = _progress >= _completionThreshold && _pathCoverage >= _pathCoverageMinimum;
    
    if (_canComplete) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_canComplete && mounted) {
          widget.onCompleted();
        }
      });
    }
  }
  
  void _resetTracing() {
    setState(() {
      _userPoints.clear();
      _userStrokes.clear();
      _currentStroke = [];
      _progress = 0.0;
      _accuracy = 0.0;
      _pathCoverage = 0.0;
      _canComplete = false;
    });
  }

  // The rest of the calculation methods remain unchanged
  List<bool> _calculateSegmentsCovered() {
    // Implementation unchanged
    if (_guidePoints.length < 2) return [];
    
    List<bool> segmentsCovered = List.filled(_guidePoints.length - 1, false);
    
    for (int i = 0; i < _guidePoints.length - 1; i++) {
      Offset start = _guidePoints[i];
      Offset end = _guidePoints[i + 1];
      
      bool segmentCovered = false;
      
      for (var stroke in [..._userStrokes, _currentStroke]) {
        if (stroke.length < 2) continue;
        
        bool hasPointsNearStart = false;
        bool hasPointsNearEnd = false;
        bool hasPointsInBetween = false;
        
        for (var point in stroke) {
          double distanceToStart = (point - start).distance;
          double distanceToEnd = (point - end).distance;
          
          if (distanceToStart < _proximityThreshold) {
            hasPointsNearStart = true;
          }
          
          if (distanceToEnd < _proximityThreshold) {
            hasPointsNearEnd = true;
          }
          
          double distanceToSegment = _distanceToLineSegment(point, start, end);
          if (distanceToSegment < _proximityThreshold) {
            hasPointsInBetween = true;
          }
        }
        
        if ((hasPointsNearStart || hasPointsNearEnd) && hasPointsInBetween) {
          segmentCovered = true;
          break;
        }
      }
      
      segmentsCovered[i] = segmentCovered;
    }
    
    return segmentsCovered;
  }
  
  void _updateCurrentSegment() {
    // Implementation unchanged
    if (_userPoints.isEmpty || _guidePoints.length < 2) return;
    
    Offset lastUserPoint = _userPoints.last;
    double minDistance = double.infinity;
    int closestSegment = 0;
    
    for (int i = 0; i < _guidePoints.length - 1; i++) {
      double distance = _distanceToLineSegment(
        lastUserPoint, 
        _guidePoints[i], 
        _guidePoints[i + 1]
      );
      
      if (distance < minDistance) {
        minDistance = distance;
        closestSegment = i;
      }
    }
    
    if (minDistance < _proximityThreshold) {
      _currentSegment = closestSegment;
    }
  }
  
  double _distanceToLineSegment(Offset point, Offset start, Offset end) {
    // Implementation unchanged
    double l2 = _distanceSquared(start, end);
    
    if (l2 == 0) return (point - start).distance;
    
    double t = ((point - start).dx * (end - start).dx + (point - start).dy * (end - start).dy) / l2;
    
    if (t < 0) return (point - start).distance;
    if (t > 1) return (point - end).distance;
    
    Offset projection = start + (end - start) * t;
    return (point - projection).distance;
  }
  
  double _distanceSquared(Offset a, Offset b) {
    return (b - a).distanceSquared;
  }

  @override
  Widget build(BuildContext context) {
    print("Building LetterTracingWidget for letter: ${widget.letter.id} - ${widget.letter.letter}");
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight - 150);
        
        // Initialize guide points if needed
        if (_guidePoints.isEmpty) {
          print("Updating guide points for letter: ${widget.letter.id}");
          _updateGuidePointsWithSize(size);
        }
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(51),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          // Use Column layout with fixed sizes
          child: Column(
            children: [
              // Tracing area - explicitly sized, not expanded
              Container(
                height: constraints.maxHeight - 160,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: GestureDetector(
                  onPanStart: _handlePanStart,
                  onPanUpdate: _handlePanUpdate,
                  onPanEnd: _handlePanEnd,
                  child: CustomPaint(
                    painter: LetterTracePainter(
                      guidePoints: _guidePoints,
                      userPoints: _userPoints,
                      userStrokes: _userStrokes,
                      currentStroke: _currentStroke,
                      showGuide: _showGuide,
                      pulseValue: _pulseAnimation.value,
                      currentSegment: _currentSegment,
                    ),
                    size: size,
                  ),
                ),
              ),
              
              // Clear visual separator
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border(
                    top: BorderSide(color: Colors.grey[400]!, width: 1),
                    bottom: BorderSide(color: Colors.grey[400]!, width: 1),
                  ),
                ),
              ),
              
              // Bottom Controls Panel - fixed height
              Container(
                height: 150, // Fixed height for controls
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress tracking
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Progress', 
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: _progress,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _progress > _completionThreshold ? Colors.green : Colors.blue,
                                ),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(_progress * 100).toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _progress > _completionThreshold ? Colors.green : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    
                    // Path coverage indicator
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Path Coverage', 
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: _pathCoverage,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _pathCoverage >= _pathCoverageMinimum ? Colors.green : Colors.orange,
                                ),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(_pathCoverage * 100).toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _pathCoverage >= _pathCoverageMinimum ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    
                    // Status message
                    const SizedBox(height: 8),
                    Text(
                      _canComplete
                          ? 'Great job! Perfect tracing!'
                          : _pathCoverage < _pathCoverageMinimum
                              ? 'Complete the entire letter shape'
                              : 'Follow the blue path carefully...',
                      style: TextStyle(
                        color: _canComplete ? Colors.green : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Controls
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Toggle guide visibility
                        ElevatedButton.icon(
                          onPressed: () => setState(() {
                            _showGuide = !_showGuide;
                          }),
                          icon: Icon(
                            _showGuide ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          label: Text(
                            _showGuide ? 'Hide Guide' : 'Show Guide',
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                        
                        // Reset button
                        ElevatedButton.icon(
                          onPressed: _resetTracing,
                          icon: const Icon(Icons.replay, color: Colors.white),
                          label: const Text('Reset', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LetterTracePainter extends CustomPainter {
  final List<Offset> guidePoints;
  final List<Offset> userPoints;
  final List<List<Offset>> userStrokes;
  final List<Offset> currentStroke;
  final bool showGuide;
  final double pulseValue;
  final int currentSegment;
  
  LetterTracePainter({
    required this.guidePoints,
    required this.userPoints,
    required this.userStrokes,
    required this.currentStroke,
    required this.showGuide,
    required this.pulseValue,
    required this.currentSegment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final bgPaint = Paint()
      ..color = Colors.grey.withAlpha(15)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Offset.zero & size, bgPaint);
    
    // Draw background letter shape
    _drawLetterBackground(canvas, size);
    
    // Draw guide path if enabled
    if (showGuide && guidePoints.length >= 2) {
      _drawGuidePath(canvas);
    }
    
    // Draw user's completed strokes
    for (var stroke in userStrokes) {
      _drawUserStroke(canvas, stroke);
    }
    
    // Draw current stroke being drawn
    if (currentStroke.isNotEmpty) {
      _drawUserStroke(canvas, currentStroke);
    }
  }
  
  void _drawLetterBackground(Canvas canvas, Size size) {
    // Draw a light gray representation of the letter in the background
    if (guidePoints.length < 2) return;
    
    final bgPaint = Paint()
      ..color = Colors.grey.withAlpha(40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    final bgPath = Path();
    bgPath.moveTo(guidePoints.first.dx, guidePoints.first.dy);
    
    for (int i = 1; i < guidePoints.length; i++) {
      bgPath.lineTo(guidePoints[i].dx, guidePoints[i].dy);
    }
    
    canvas.drawPath(bgPath, bgPaint);
  }
  
  void _drawGuidePath(Canvas canvas) {
    // Draw each segment of the guide path
    for (int i = 0; i < guidePoints.length - 1; i++) {
      final bool isCurrentSegment = (i == currentSegment);
      
      final paint = Paint()
        ..color = isCurrentSegment 
            ? Colors.blue.withAlpha(204)
            : Colors.blue.withAlpha(102)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isCurrentSegment ? 6.0 * pulseValue : 4.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      
      canvas.drawLine(guidePoints[i], guidePoints[i + 1], paint);
      
      // Draw dots at guide points
      final bool isStart = (i == 0);
      final bool isEnd = (i == guidePoints.length - 2);
      
      double dotSize = isStart ? 12.0 * pulseValue : (isEnd ? 12.0 : 6.0);
      Color dotColor = isStart ? Colors.green : (isEnd ? Colors.red : Colors.blue.withAlpha(153));
      
      canvas.drawCircle(
        guidePoints[i],
        dotSize,
        Paint()..color = dotColor,
      );
      
      // Draw the last endpoint
      if (i == guidePoints.length - 2) {
        canvas.drawCircle(
          guidePoints[i + 1],
          12.0,
          Paint()..color = Colors.red,
        );
      }
      
      // Draw direction arrow at midpoint
      if (i < guidePoints.length - 1) {
        final start = guidePoints[i];
        final end = guidePoints[i + 1];
        final midPoint = Offset(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2,
        );
        
        // Calculate angle
        final angle = atan2(end.dy - start.dy, end.dx - start.dx);
        
        _drawArrow(canvas, midPoint, angle);
      }
    }
  }
  
  void _drawArrow(Canvas canvas, Offset position, double angle) {
    const arrowSize = 10.0;
    
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);
    
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(-arrowSize, arrowSize / 2);
    path.lineTo(-arrowSize, -arrowSize / 2);
    path.close();
    
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, paint);
    canvas.restore();
  }
  
  void _drawUserStroke(Canvas canvas, List<Offset> stroke) {
    if (stroke.length < 2) return;
    
    final userPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    final userPath = Path();
    userPath.moveTo(stroke.first.dx, stroke.first.dy);
    
    for (int i = 1; i < stroke.length; i++) {
      userPath.lineTo(stroke[i].dx, stroke[i].dy);
    }
    
    canvas.drawPath(userPath, userPaint);
    
    // Draw start point for this stroke
    canvas.drawCircle(
      stroke.first,
      6.0,
      Paint()..color = Colors.green[700]!,
    );
    
    // Draw current point if this is the active stroke
    if (stroke == currentStroke && stroke.isNotEmpty) {
      canvas.drawCircle(
        stroke.last,
        8.0,
        Paint()..color = Colors.deepOrange,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LetterTracePainter oldDelegate) {
    return oldDelegate.userPoints != userPoints ||
        oldDelegate.userStrokes != userStrokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.showGuide != showGuide ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.currentSegment != currentSegment;
  }
}
import 'package:flutter/material.dart';
import '../../domain/entities/qubee.dart';

class LetterTracingWidget extends StatefulWidget {
  final Qubee letter;
  final VoidCallback onCompleted;

  const LetterTracingWidget({
    required this.letter,
    required this.onCompleted,
    super.key,
  });

  @override
  State<LetterTracingWidget> createState() => _LetterTracingWidgetState();
}

class _LetterTracingWidgetState extends State<LetterTracingWidget> with SingleTickerProviderStateMixin {
  final List<Offset> _points = [];
  bool _isTracing = false;
  double _progress = 0.0;
  bool _canComplete = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _checkProgressAndComplete() {
    // Simple completion logic - in a real app this would be more sophisticated
    if (_progress > 0.7) { // 70% of the path traced
      setState(() {
        _canComplete = true;
      });
      
      // Auto-complete after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        if (_canComplete) {
          widget.onCompleted();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Letter template (faded background)
          Center(
            child: Text(
              widget.letter.letter,
              style: TextStyle(
                fontSize: 180,
                fontWeight: FontWeight.bold,
                color: Colors.grey.withOpacity(0.1),
              ),
            ),
          ),
          
          // Guide path
          CustomPaint(
            painter: GuidePathPainter(
              tracingPoints: widget.letter.tracingPoints,
              pulseValue: _pulseAnimation.value,
            ),
          ),
          
          // User's drawing
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                _isTracing = true;
                _points.add(details.localPosition);
              });
            },
            onPanUpdate: (details) {
              if (_isTracing) {
                setState(() {
                  _points.add(details.localPosition);
                  
                  // Update progress - in a real app this would check alignment with the path
                  final newProgress = _points.length / (widget.letter.tracingPoints.length * 10);
                  _progress = newProgress > 1.0 ? 1.0 : newProgress;
                  
                  _checkProgressAndComplete();
                });
              }
            },
            onPanEnd: (details) {
              setState(() {
                _isTracing = false;
                _checkProgressAndComplete();
              });
            },
            child: CustomPaint(
              painter: TracingPainter(_points),
            ),
          ),
          
          // Progress indicator
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _progress > 0.7 ? Colors.green : Colors.blue,
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  _canComplete
                      ? 'Great job! Almost there...'
                      : '${(_progress * 100).toInt()}% completed',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GuidePathPainter extends CustomPainter {
  final List<Map<String, double>> tracingPoints;
  final double pulseValue;
  
  GuidePathPainter({required this.tracingPoints, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (tracingPoints.isEmpty) return;
    
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0 * pulseValue
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    final path = Path();
    
    // Convert normalized coordinates to actual pixel positions
    final firstPoint = _normalizedToPixel(tracingPoints.first, size);
    path.moveTo(firstPoint.dx, firstPoint.dy);
    
    for (int i = 1; i < tracingPoints.length; i++) {
      final point = _normalizedToPixel(tracingPoints[i], size);
      path.lineTo(point.dx, point.dy);
    }
    
    // Draw dots at guide points
    for (var point in tracingPoints) {
      final pixelPoint = _normalizedToPixel(point, size);
      canvas.drawCircle(
        pixelPoint,
        8.0 * pulseValue,
        Paint()..color = Colors.blue.withOpacity(0.8),
      );
    }
    
    canvas.drawPath(path, paint);
  }
  
  Offset _normalizedToPixel(Map<String, double> point, Size size) {
    return Offset(
      point['x']! * size.width,
      point['y']! * size.height,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TracingPainter extends CustomPainter {
  final List<Offset> points;
  
  TracingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
    
    // Draw dot at current position
    if (points.isNotEmpty) {
      canvas.drawCircle(points.last, 5.0, Paint()..color = Colors.orange);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
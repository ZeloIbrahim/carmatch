import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ScoreGauge extends StatefulWidget {
  final int score;
  final double size;

  const ScoreGauge({super.key, required this.score, this.size = 56});

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _animation = Tween<double>(begin: 0, end: widget.score.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couleur = AppTheme.scoreColor(widget.score);
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            painter: _GaugePainter(valeur: _animation.value, couleur: couleur),
            child: Center(
              child: Text(
                "${_animation.value.round()}",
                style: TextStyle(
                  fontSize: widget.size * 0.32,
                  fontWeight: FontWeight.bold,
                  color: couleur,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double valeur; // 0-100
  final Color couleur;

  _GaugePainter({required this.valeur, required this.couleur});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const startAngle = 2.35619; // 135deg en radians
    const sweepMax = 4.71239; // 270deg en radians

    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final valuePaint = Paint()
      ..color = couleur
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepMax,
      false,
      trackPaint,
    );

    final sweep = sweepMax * (valeur.clamp(0, 100) / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.valeur != valeur || oldDelegate.couleur != couleur;
}

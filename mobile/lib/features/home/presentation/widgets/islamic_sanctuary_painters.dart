import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Subtle architectural mosque skyline etched behind the hero prayer card.
/// Uses crisp vector geometry (central dome, arched portals, flanking minarets)
/// rather than heavy bitmap images.
class MosqueSkylinePainter extends CustomPainter {
  final Color lineColor;
  final Color fillColor;

  const MosqueSkylinePainter({
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final baseY = size.height;
    final centerX = size.width * 0.56;

    // Ground plinth
    canvas.drawRect(
      Rect.fromLTRB(centerX - 110, baseY - 12, centerX + 110, baseY),
      fillPaint,
    );

    // Central dome & base drum
    canvas.drawRect(
      Rect.fromLTWH(centerX - 36, baseY - 46, 72, 34),
      fillPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(centerX - 36, baseY - 46, 72, 34),
      strokePaint,
    );

    final domePath = Path()
      ..moveTo(centerX - 34, baseY - 46)
      ..cubicTo(
        centerX - 34,
        baseY - 78,
        centerX - 8,
        baseY - 86,
        centerX,
        baseY - 94,
      )
      ..cubicTo(
        centerX + 8,
        baseY - 86,
        centerX + 34,
        baseY - 78,
        centerX + 34,
        baseY - 46,
      )
      ..close();
    canvas.drawPath(domePath, fillPaint);
    canvas.drawPath(domePath, strokePaint);

    // Dome finial
    canvas.drawLine(
      Offset(centerX, baseY - 94),
      Offset(centerX, baseY - 103),
      strokePaint,
    );
    canvas.drawCircle(Offset(centerX, baseY - 105), 2.2, strokePaint);

    // Side domes
    for (final dx in [-56.0, 56.0]) {
      final sx = centerX + dx;
      canvas.drawRect(
        Rect.fromLTWH(sx - 20, baseY - 36, 40, 24),
        fillPaint,
      );
      final smallDome = Path()
        ..moveTo(sx - 18, baseY - 36)
        ..quadraticBezierTo(sx, baseY - 62, sx + 18, baseY - 36)
        ..close();
      canvas.drawPath(smallDome, fillPaint);
      canvas.drawPath(smallDome, strokePaint);
    }

    // Flanking minarets
    for (final dx in [-90.0, 90.0]) {
      final mx = centerX + dx;
      canvas.drawRect(
        Rect.fromLTWH(mx - 6, baseY - 82, 12, 70),
        fillPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(mx - 6, baseY - 82, 12, 70),
        strokePaint,
      );
      // Balcony
      canvas.drawRect(
        Rect.fromLTWH(mx - 9, baseY - 60, 18, 4),
        strokePaint,
      );
      // Minaret cap
      final cap = Path()
        ..moveTo(mx - 7, baseY - 82)
        ..quadraticBezierTo(mx, baseY - 98, mx + 7, baseY - 82)
        ..close();
      canvas.drawPath(cap, fillPaint);
      canvas.drawPath(cap, strokePaint);
      canvas.drawLine(Offset(mx, baseY - 92), Offset(mx, baseY - 98), strokePaint);
    }

    // Subtle Mihrab arch windows
    for (final dx in [-18.0, 0.0, 18.0]) {
      final wx = centerX + dx;
      final arch = Path()
        ..moveTo(wx - 4.5, baseY - 14)
        ..lineTo(wx - 4.5, baseY - 28)
        ..quadraticBezierTo(wx, baseY - 35, wx + 4.5, baseY - 28)
        ..lineTo(wx + 4.5, baseY - 14)
        ..close();
      canvas.drawPath(arch, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MosqueSkylinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor || oldDelegate.fillColor != fillColor;
  }
}

/// Circular progress arc indicating time remaining until next waqt.
class CountdownRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color activeColor;

  const CountdownRingPainter({
    required this.progress,
    required this.trackColor,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 4;
    const strokeWidth = 3.5;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * math.pi * progress.clamp(0.06, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CountdownRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.activeColor != activeColor;
  }
}

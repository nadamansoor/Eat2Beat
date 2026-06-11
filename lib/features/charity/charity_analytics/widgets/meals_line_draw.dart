import 'dart:ui';
import 'package:eat2beat/features/charity/charity_analytics/models/analytics_charity_model.dart';
import 'package:flutter/material.dart';
import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';


class MealsLineChart extends StatelessWidget {
  final List<ChartPoint> points;
  const MealsLineChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 200,
      child: CustomPaint(
        painter: _LineChartPainter(points: points),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartPoint> points;

  _LineChartPainter({required this.points});

  static const double _paddingLeft = 36;
  static const double _paddingRight = 16;
  static const double _paddingTop = 16;
  static const double _paddingBottom = 32;

  @override
  void paint(Canvas canvas, Size size) {
    final chartW = size.width - _paddingLeft - _paddingRight;
    final chartH = size.height - _paddingTop - _paddingBottom;

    final maxVal = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final minVal = 0.0;
    final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;

    // ── Grid lines ───────────────────────────────────────────────────────────
    final gridPaint = Paint()
      ..color = const Color(0xFFE8E4F4)
      ..strokeWidth = 1;

    const gridCount = 5;
    for (int i = 0; i <= gridCount; i++) {
      final y = _paddingTop + chartH * (1 - i / gridCount);
      canvas.drawLine(
        Offset(_paddingLeft, y),
        Offset(size.width - _paddingRight, y),
        gridPaint,
      );
      // Y-axis label
      final labelVal = (minVal + range * i / gridCount).round();
      _drawText(
        canvas,
        '$labelVal',
        Offset(0, y - 7),
        width: _paddingLeft - 4,
        color: AppColors.textSecondary,
        fontSize: 9,
        align: TextAlign.right,
      );
    }

    // ── Compute pixel positions ───────────────────────────────────────────────
    List<Offset> offsets = [];
    for (int i = 0; i < points.length; i++) {
      final x = _paddingLeft + chartW * i / (points.length - 1);
      final y = _paddingTop +
          chartH * (1 - (points[i].value - minVal) / range);
      offsets.add(Offset(x, y));
    }

    // ── Gradient fill ────────────────────────────────────────────────────────
    final fillPath = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 1; i < offsets.length; i++) {
      final cp1 = Offset(
          (offsets[i - 1].dx + offsets[i].dx) / 2, offsets[i - 1].dy);
      final cp2 = Offset(
          (offsets[i - 1].dx + offsets[i].dx) / 2, offsets[i].dy);
      fillPath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i].dx, offsets[i].dy);
    }
    fillPath.lineTo(offsets.last.dx, _paddingTop + chartH);
    fillPath.lineTo(offsets.first.dx, _paddingTop + chartH);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withOpacity(0.25),
          AppColors.primary.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(
          _paddingLeft, _paddingTop, chartW, chartH));
    canvas.drawPath(fillPath, fillPaint);

    // ── Line ─────────────────────────────────────────────────────────────────
    final linePath = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 1; i < offsets.length; i++) {
      final cp1 = Offset(
          (offsets[i - 1].dx + offsets[i].dx) / 2, offsets[i - 1].dy);
      final cp2 = Offset(
          (offsets[i - 1].dx + offsets[i].dx) / 2, offsets[i].dy);
      linePath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, offsets[i].dx, offsets[i].dy);
    }
    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    // ── Dots ──────────────────────────────────────────────────────────────────
    final dotOuter = Paint()..color = AppColors.primary;
    final dotInner = Paint()..color = Colors.white;
    for (final o in offsets) {
      canvas.drawCircle(o, 4.5, dotOuter);
      canvas.drawCircle(o, 2.5, dotInner);
    }

    // ── X-axis labels ─────────────────────────────────────────────────────────
    // Show only first, middle, and last to avoid overlap
    final labelIndices = <int>[
      0,
      points.length ~/ 2,
      points.length - 1,
    ];
    for (final i in labelIndices.toSet()) {
      _drawText(
        canvas,
        points[i].label,
        Offset(offsets[i].dx - 24, size.height - _paddingBottom + 6),
        width: 48,
        color: AppColors.textSecondary,
        fontSize: 9,
        align: TextAlign.center,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position, {
    required double width,
    required Color color,
    required double fontSize,
    TextAlign align = TextAlign.left,
  }) {
    final tp = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(
              color: color, fontSize: fontSize, fontWeight: FontWeight.w500)),
      textAlign: align,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    tp.paint(canvas, position);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => old.points != points;
}
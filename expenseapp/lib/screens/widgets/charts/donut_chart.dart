import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Datos para el gráfico de dona
class DonutChartData {
  final String label;
  final double value;
  final Color color;

  DonutChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Widget de gráfico de dona personalizado
class DonutChartWidget extends StatefulWidget {
  final List<DonutChartData> data;
  final double size;
  final double strokeWidth;
  final Widget? centerWidget;
  final bool showLabels;

  const DonutChartWidget({
    super.key,
    required this.data,
    this.size = 200,
    this.strokeWidth = 30,
    this.centerWidget,
    this.showLabels = true,
  });

  @override
  State<DonutChartWidget> createState() => _DonutChartWidgetState();
}

class _DonutChartWidgetState extends State<DonutChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
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
    final total = widget.data.fold<double>(0, (sum, d) => sum + d.value);

    return Row(
      children: [
        // Gráfico
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTapUp: (details) => _handleTap(details, total),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _DonutChartPainter(
                    data: widget.data,
                    total: total,
                    strokeWidth: widget.strokeWidth,
                    animationValue: _animation.value,
                    selectedIndex: _selectedIndex,
                  ),
                );
              },
            ),
          ),
        ),
        
        // Leyenda
        if (widget.showLabels)
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final percentage = total > 0 ? (item.value / total * 100) : 0;
                final isSelected = _selectedIndex == index;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = isSelected ? null : index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: item.color.withOpacity(0.4),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? item.color : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _handleTap(TapUpDetails details, double total) {
    // Implementación simplificada de detección de tap
    setState(() {
      if (_selectedIndex != null) {
        _selectedIndex = null;
      }
    });
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<DonutChartData> data;
  final double total;
  final double strokeWidth;
  final double animationValue;
  final int? selectedIndex;

  _DonutChartPainter({
    required this.data,
    required this.total,
    required this.strokeWidth,
    required this.animationValue,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    
    double startAngle = -math.pi / 2; // Empezar desde arriba

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / total) * 2 * math.pi * animationValue;
      final isSelected = selectedIndex == i;
      
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? strokeWidth + 4 : strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = item.color;

      // Offset para segmento seleccionado
      var drawCenter = center;
      if (isSelected) {
        final midAngle = startAngle + sweepAngle / 2;
        drawCenter = Offset(
          center.dx + math.cos(midAngle) * 5,
          center.dy + math.sin(midAngle) * 5,
        );
      }

      canvas.drawArc(
        Rect.fromCircle(center: drawCenter, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}


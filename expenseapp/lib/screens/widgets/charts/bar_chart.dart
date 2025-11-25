import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../config/constants.dart';

/// Datos para gráfico de barras
class BarChartData {
  final String label;
  final double value;
  final Color? color;

  BarChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

/// Widget de gráfico de barras personalizado
class BarChartWidget extends StatefulWidget {
  final List<BarChartData> data;
  final double height;
  final Color? defaultColor;
  final bool showValues;
  final bool horizontal;

  const BarChartWidget({
    super.key,
    required this.data,
    this.height = 200,
    this.defaultColor,
    this.showValues = true,
    this.horizontal = false,
  });

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    if (widget.data.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('Sin datos')),
      );
    }

    final maxValue = widget.data.map((d) => d.value).reduce(math.max);
    final defaultColor = widget.defaultColor ?? Theme.of(context).primaryColor;

    if (widget.horizontal) {
      return _buildHorizontalChart(maxValue, defaultColor);
    }

    return _buildVerticalChart(maxValue, defaultColor);
  }

  Widget _buildVerticalChart(double maxValue, Color defaultColor) {
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.data.map((item) {
              final barHeight = maxValue > 0
                  ? (item.value / maxValue) * (widget.height - 30) * _animation.value
                  : 0.0;
              final color = item.color ?? defaultColor;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.showValues)
                        Text(
                          _formatValue(item.value),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 4),
                      Container(
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalChart(double maxValue, Color defaultColor) {
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.data.map((item) {
              final color = item.color ?? defaultColor;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        item.label,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final barWidth = maxValue > 0
                              ? (item.value / maxValue) * constraints.maxWidth * _animation.value
                              : 0.0;
                          
                          return Stack(
                            children: [
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: barWidth,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    if (widget.showValues) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 50,
                        child: Text(
                          _formatValue(item.value),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String _formatValue(double value) {
    final symbol = AppConstants.currencySymbol;
    if (value >= 1000000) {
      return '$symbol${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '$symbol${(value / 1000).toStringAsFixed(1)}K';
    }
    return '$symbol${value.toStringAsFixed(0)}';
  }
}

/// Gráfico de barras comparativo (dos series)
class ComparisonBarChartWidget extends StatelessWidget {
  final List<String> labels;
  final List<double> series1;
  final List<double> series2;
  final String series1Label;
  final String series2Label;
  final Color series1Color;
  final Color series2Color;
  final double height;

  const ComparisonBarChartWidget({
    super.key,
    required this.labels,
    required this.series1,
    required this.series2,
    this.series1Label = 'Serie 1',
    this.series2Label = 'Serie 2',
    this.series1Color = Colors.blue,
    this.series2Color = Colors.orange,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('Sin datos')),
      );
    }

    final maxValue = [...series1, ...series2].reduce(math.max);

    return Column(
      children: [
        // Leyenda
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(series1Label, series1Color),
            const SizedBox(width: 24),
            _buildLegendItem(series2Label, series2Color),
          ],
        ),
        const SizedBox(height: 16),
        // Gráfico
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(labels.length, (index) {
              final value1 = index < series1.length ? series1[index] : 0.0;
              final value2 = index < series2.length ? series2[index] : 0.0;
              final bar1Height = maxValue > 0 
                  ? (value1 / maxValue) * (height - 30) 
                  : 0.0;
              final bar2Height = maxValue > 0 
                  ? (value2 / maxValue) * (height - 30) 
                  : 0.0;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 12,
                            height: bar1Height,
                            decoration: BoxDecoration(
                              color: series1Color,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            width: 12,
                            height: bar2Height,
                            decoration: BoxDecoration(
                              color: series2Color,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: const TextStyle(fontSize: 9),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}


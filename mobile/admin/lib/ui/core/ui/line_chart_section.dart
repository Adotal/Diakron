import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class LineChartSection extends StatelessWidget {
  final String title;
  final int selectedTab;
  final Function(int) onTabChanged;

  const LineChartSection({
    super.key,
    required this.title,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)
                ],
              ),
              child: Row(
                children: [
                  _buildTabButton("Mes", 0),
                  _buildTabButton("Semana", 1),
                  _buildTabButton("Hoy", 2),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 25),
        Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ],
          ),
          child: CustomPaint(
            painter: _LineChartPainter(color: AppColors.greenDiakron1),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final Color color;
  _LineChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(size.width * 0.2, size.height * 0.9, size.width * 0.3,
        size.height * 0.2, size.width * 0.5, size.height * 0.4);
    path.cubicTo(size.width * 0.7, size.height * 0.6, size.width * 0.8,
        size.height * 0.1, size.width, size.height * 0.5);

    canvas.drawPath(path, paintLine);

    final paintDots = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(0, size.height * 0.7), 4, paintDots);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 4, paintDots);
    canvas.drawCircle(Offset(size.width, size.height * 0.5), 4, paintDots);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
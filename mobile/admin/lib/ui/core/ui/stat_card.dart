import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double percentage;
  final bool isDark;
  final Color progressColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    this.isDark = false,
    required this.progressColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.greenDiakron1 : AppColors.greenDiakron3;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black87;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: AppColors.greenDiakron1.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("0%", style: TextStyle(fontSize: 12, color: subtitleColor)),
                  Text("${(percentage * 100).toInt()}%",
                      style: TextStyle(fontSize: 12, color: subtitleColor)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: isDark ? Colors.white24 : AppColors.backgroundDiakron,
                  color: progressColor,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool lightText;

  const AppLogo({super.key, this.size = 48, this.showText = true, this.lightText = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Icon(Icons.task_alt_rounded, color: Colors.white, size: size * 0.5),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.25),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Task', style: TextStyle(color: lightText ? Colors.white : AppTheme.textPrimary, fontSize: size * 0.35, fontWeight: FontWeight.w700, height: 1.1)),
              Text('Nest', style: TextStyle(color: AppTheme.accent, fontSize: size * 0.35, fontWeight: FontWeight.w700, height: 1.1)),
            ],
          ),
        ],
      ],
    );
  }
}

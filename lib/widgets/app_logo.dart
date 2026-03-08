import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Renders the TaskNest brand logo — works without any asset files.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool darkBackground;

  const AppLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.darkBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, Color(0xFF7986CB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.task_alt_rounded,
                    color: Colors.white, size: size * 0.55),
                Positioned(
                  bottom: size * 0.08,
                  right: size * 0.08,
                  child: Container(
                    width: size * 0.28,
                    height: size * 0.28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC407A),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Icon(Icons.bolt_rounded,
                          color: Colors.white, size: size * 0.18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Task',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size * 0.5,
                    fontWeight: FontWeight.w700,
                    color: darkBackground ? Colors.white : AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'Nest',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size * 0.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dashboard/core/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color? backgroundColor;

  const CustomCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.only(top: 2.0),
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: borderColor ?? AppColors.primary.withOpacity(0.5),
          width: borderWidth,
          style: BorderStyle.solid,
        ),
      ),
      margin: margin,
      color: backgroundColor,
      child: child,
    );
  }
}

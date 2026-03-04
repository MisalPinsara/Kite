import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.icon,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: isOutlined ? BorderSide(color: textColor, width: 2) : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, color: textColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

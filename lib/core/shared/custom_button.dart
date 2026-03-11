import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final BorderSide? border;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget? sIcon;
  final Widget? pIcon;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow>? shadows;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = Colors.blue, // Default color
    this.textColor = Colors.white,
    this.width, // If null, it will fit the content
    this.height = 50,
    this.borderRadius = 8.0,
    this.border,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.pIcon,
    this.sIcon,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border != null ? Border.fromBorderSide(border!) : null,
          boxShadow: shadows,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min, // Keeps content centered
            children: [
              if (pIcon != null) ...[
                pIcon!,
                Spacer(),
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
              if (sIcon != null) ...[
                Spacer(),
                sIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
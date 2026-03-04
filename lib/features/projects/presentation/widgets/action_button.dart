import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';

// ...existing code...
class ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final BuildContext context;

  const ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.context,
    this.isPrimary = true,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: context.elementSpacing * 0.7, horizontal: context.horizontalPadding * 0.6),
        decoration: BoxDecoration(
          color: widget.isPrimary
              ? (Colors.blue.shade600.withValues(alpha: _isPressed ? 0.8 : 1.0))
              : (Colors.grey.shade200.withValues(alpha: _isPressed ? 0.7 : 1.0)),
          borderRadius: BorderRadius.circular(12),
          border: widget.isPrimary
              ? null
              : Border.all(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
          boxShadow: _isPressed
              ? []
              : [
            BoxShadow(
              color: (widget.isPrimary ? Colors.blue : Colors.grey)
                  .withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.isPrimary ? Colors.white : Colors.black,
              size: 18,
            ),
            SizedBox(width: context.elementSpacing * 0.4),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: context.platformLabelFontSize,
                fontWeight: FontWeight.w700,
                color: widget.isPrimary ? Colors.white : Colors.black,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
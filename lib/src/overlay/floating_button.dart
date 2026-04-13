import 'package:flutter/material.dart';
import 'flow_theme.dart';

class FlowFloatingButton extends StatefulWidget {
  final VoidCallback onTap;
  final Offset position;
  final ValueChanged<Offset> onPositionChanged;

  const FlowFloatingButton({
    super.key,
    required this.onTap,
    required this.position,
    required this.onPositionChanged,
  });

  @override
  State<FlowFloatingButton> createState() => _FlowFloatingButtonState();
}

class _FlowFloatingButtonState extends State<FlowFloatingButton> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      right: widget.position.dx,
      bottom: widget.position.dy,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanUpdate: (details) {
          final newPos = Offset(
            (widget.position.dx - details.delta.dx).clamp(
              8,
              screenSize.width - 60,
            ),
            (widget.position.dy - details.delta.dy).clamp(
              8,
              screenSize.height - 60,
            ),
          );
          widget.onPositionChanged(newPos);
        },
        onPanEnd: (_) => setState(() => _isDragging = false),
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isDragging ? 1.0 : 0.85,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: FlowTheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: FlowTheme.cyan.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: FlowTheme.cyan.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.track_changes_rounded,
                    color: FlowTheme.cyan,
                    size: 22,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: FlowTheme.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

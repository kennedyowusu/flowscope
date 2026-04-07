import 'package:flutter/material.dart';
import 'flow_theme.dart';

class FlowFloatingButton extends StatefulWidget {
  final VoidCallback onTap;

  const FlowFloatingButton({super.key, required this.onTap});

  @override
  State<FlowFloatingButton> createState() => _FlowFloatingButtonState();
}

class _FlowFloatingButtonState extends State<FlowFloatingButton> {
  Offset _position = const Offset(16, 100);
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      right: _position.dx,
      bottom: _position.dy,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              (_position.dx - details.delta.dx).clamp(8, screenSize.width - 60),
              (_position.dy - details.delta.dy).clamp(
                8,
                screenSize.height - 60,
              ),
            );
          });
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
                color: FlowTheme.cyan.withAlpha(153),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: FlowTheme.cyan.withAlpha(51),
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

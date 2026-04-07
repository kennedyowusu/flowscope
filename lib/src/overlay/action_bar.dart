import 'package:flutter/material.dart';
import 'flow_theme.dart';

class FlowActionBar extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onPause;
  final VoidCallback onClose;
  final bool isPaused;

  const FlowActionBar({
    super.key,
    required this.onClear,
    required this.onPause,
    required this.onClose,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: FlowTheme.surface,
        border: Border(
          top: BorderSide(color: FlowTheme.surfaceElevated, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.delete_sweep_outlined,
            label: 'CLEAR',
            color: FlowTheme.textSecondary,
            onTap: onClear,
          ),
          _ActionButton(
            icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            label: isPaused ? 'RESUME' : 'PAUSE',
            color: isPaused ? FlowTheme.green : FlowTheme.textSecondary,
            onTap: onPause,
          ),
          _ActionButton(
            icon: Icons.keyboard_arrow_down_rounded,
            label: 'CLOSE',
            color: FlowTheme.cyan,
            onTap: onClose,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: FlowTheme.styleLabel.copyWith(color: color)),
        ],
      ),
    );
  }
}

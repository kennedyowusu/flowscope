import 'package:flutter/material.dart';
import 'flow_theme.dart';

class FlowTagBadge extends StatelessWidget {
  final FlowTag tag;

  const FlowTagBadge({super.key, required this.tag});

  String get _label => switch (tag) {
    FlowTag.state => 'STATE',
    FlowTag.network => 'NETWORK',
    FlowTag.log => 'LOG',
    FlowTag.error => 'ERROR',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: FlowTheme.tagBackground(tag),
        border: Border.all(
          color: FlowTheme.tagForeground(tag).withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontFamily: FlowTheme.fontMono,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: FlowTheme.tagForeground(tag),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

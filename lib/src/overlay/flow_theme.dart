import 'package:flutter/material.dart';

class FlowTheme {
  FlowTheme._();

  // Backgrounds
  static const background = Color(0xFF0D0D0D);
  static const surface = Color(0xFF1A1A1A);
  static const surfaceElevated = Color(0xFF242424);

  // Accents
  static const cyan = Color(0xFF4FC3F7);
  static const green = Color(0xFF00E676);
  static const yellow = Color(0xFFFFD740);
  static const red = Color(0xFFFF5252);
  static const orange = Color(0xFFFD7400);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF888888);
  static const textMuted = Color(0xFF555555);

  // Tag colors
  static Color tagBackground(FlowTag tag) {
    return switch (tag) {
      FlowTag.state => cyan.withAlpha(51),
      FlowTag.network => green.withAlpha(51),
      FlowTag.log => yellow.withAlpha(51),
      FlowTag.error => red.withAlpha(51),
    };
  }

  static Color tagForeground(FlowTag tag) {
    return switch (tag) {
      FlowTag.state => cyan,
      FlowTag.network => green,
      FlowTag.log => yellow,
      FlowTag.error => red,
    };
  }

  static Color timelineBar(FlowTag tag) => tagForeground(tag);

  // Typography
  static const fontMono = 'monospace';

  static const styleTimestamp = TextStyle(
    fontFamily: fontMono,
    fontSize: 12,
    color: textSecondary,
  );

  static const styleProviderName = TextStyle(
    fontFamily: fontMono,
    fontSize: 13,
    color: textPrimary,
  );

  static const styleValue = TextStyle(
    fontFamily: fontMono,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  static const styleLabel = TextStyle(
    fontSize: 11,
    color: textSecondary,
    letterSpacing: 1.2,
  );

  static const styleHeader = TextStyle(
    fontFamily: fontMono,
    fontSize: 14,
    color: cyan,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );
}

enum FlowTag { state, network, log, error }

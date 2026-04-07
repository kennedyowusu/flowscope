import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../observers/riverpod_observer.dart';
import 'floating_button.dart';
import 'debug_panel.dart';

class FlowScope extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const FlowScope({super.key, required this.child, this.enabled = true});

  @override
  State<FlowScope> createState() => _FlowScopeState();
}

class _FlowScopeState extends State<FlowScope> {
  bool _panelVisible = false;

  void _openPanel() => setState(() => _panelVisible = true);
  void _closePanel() => setState(() => _panelVisible = false);

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return ProviderScope(
      observers: [FlowScopeObserver()],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => Stack(
                  children: [
                    widget.child,
                    if (!_panelVisible) FlowFloatingButton(onTap: _openPanel),
                    if (_panelVisible) _PanelOverlay(onClose: _closePanel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const _PanelOverlay({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black.withValues(alpha: 0.4),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: FlowDebugPanel(onClose: onClose),
            ),
          ),
        ),
      ),
    );
  }
}

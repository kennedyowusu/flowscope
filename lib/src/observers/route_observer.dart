import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../core/event.dart';
import '../core/store.dart';

const _uuid = Uuid();

class FlowScopeRouteObserver extends NavigatorObserver {
  static String _currentScreen = 'Unknown';

  static String get currentScreen => _currentScreen;

  void _updateScreen(String? name) {
    if (name != null && name.isNotEmpty) {
      _currentScreen = name;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = route.settings.name ?? route.runtimeType.toString();
    _updateScreen(name);

    FlowStore.instance.add(
      LogEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        message: 'Navigated to $name',
        level: FlowLogLevel.info,
        data: {'screen': name, 'action': 'push'},
      ),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name =
        previousRoute?.settings.name ??
        previousRoute?.runtimeType.toString() ??
        'Unknown';
    _updateScreen(name);

    FlowStore.instance.add(
      LogEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        message: 'Returned to $name',
        level: FlowLogLevel.info,
        data: {'screen': name, 'action': 'pop'},
      ),
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final name =
        newRoute?.settings.name ??
        newRoute?.runtimeType.toString() ??
        'Unknown';
    _updateScreen(name);

    FlowStore.instance.add(
      LogEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        message: 'Replaced with $name',
        level: FlowLogLevel.info,
        data: {'screen': name, 'action': 'replace'},
      ),
    );
  }
}

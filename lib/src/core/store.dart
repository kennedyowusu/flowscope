import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'event.dart';

class FlowStore extends ChangeNotifier {
  FlowStore._();
  static final FlowStore instance = FlowStore._();

  final _events = <FlowEvent>[];
  bool _isPaused = false;
  String _currentScreen = 'Unknown';

  UnmodifiableListView<FlowEvent> get events =>
      UnmodifiableListView(_events.reversed.toList());

  List<StateEvent> get stateEvents =>
      _events.whereType<StateEvent>().toList().reversed.toList();

  List<NetworkEvent> get networkEvents =>
      _events.whereType<NetworkEvent>().toList().reversed.toList();

  List<LogEvent> get logEvents =>
      _events.whereType<LogEvent>().toList().reversed.toList();

  bool get isPaused => _isPaused;
  String get currentScreen => _currentScreen;

  void setCurrentScreen(String screen) {
    _currentScreen = screen;
  }

  void add(FlowEvent event) {
    if (_isPaused) return;
    _events.add(event);
    notifyListeners();
  }

  void pause() {
    _isPaused = true;
    notifyListeners();
  }

  void resume() {
    _isPaused = false;
    notifyListeners();
  }

  void clear() {
    _events.clear();
    notifyListeners();
  }
}

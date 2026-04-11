import 'package:uuid/uuid.dart';
import '../core/event.dart';
import '../core/store.dart';

const _uuid = Uuid();

class FlowLogger {
  FlowLogger._();

  static void log(
    String message, {
    Object? data,
    FlowLogLevel level = FlowLogLevel.info,
  }) {
    FlowStore.instance.add(
      LogEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        message: message,
        data: data,
        level: level,
        screen: FlowStore.instance.currentScreen,
      ),
    );
  }
}

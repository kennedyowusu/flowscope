enum FlowEventSource { state, network, ui }

enum NetworkStatus { success, error, pending }

sealed class FlowEvent {
  final String id;
  final DateTime timestamp;
  final FlowEventSource source;

  const FlowEvent({
    required this.id,
    required this.timestamp,
    required this.source,
  });
}

class StateEvent extends FlowEvent {
  final String providerName;
  final Object? previousValue;
  final Object? newValue;

  const StateEvent({
    required super.id,
    required super.timestamp,
    required this.providerName,
    required this.previousValue,
    required this.newValue,
  }) : super(source: FlowEventSource.state);
}

class NetworkEvent extends FlowEvent {
  final String url;
  final String method;
  final int? statusCode;
  final Object? requestBody;
  final Object? responseBody;
  final Duration? duration;
  final NetworkStatus status;

  const NetworkEvent({
    required super.id,
    required super.timestamp,
    required this.url,
    required this.method,
    required this.status,
    this.statusCode,
    this.requestBody,
    this.responseBody,
    this.duration,
  }) : super(source: FlowEventSource.network);
}

class LogEvent extends FlowEvent {
  final String message;
  final Object? data;
  final FlowLogLevel level;

  const LogEvent({
    required super.id,
    required super.timestamp,
    required this.message,
    required this.level,
    this.data,
  }) : super(source: FlowEventSource.ui);
}

enum FlowLogLevel { info, success, warning, error }

/// The source of a [FlowEvent] — where it originated.
enum FlowEventSource {
  /// A Riverpod state change.
  state,

  /// A network request captured by [FlowScopeDioInterceptor].
  network,

  /// A manual log from [FlowLogger].
  ui,
}

/// The status of a captured network request.
enum NetworkStatus {
  /// Request completed successfully.
  success,

  /// Request failed with an error.
  error,

  /// Request is in flight.
  pending,
}

/// Base class for all events captured by FlowScope.
sealed class FlowEvent {
  /// Unique identifier for this event.
  final String id;

  /// When this event occurred.
  final DateTime timestamp;

  /// Where this event originated.
  final FlowEventSource source;

  const FlowEvent({
    required this.id,
    required this.timestamp,
    required this.source,
  });
}

/// A Riverpod state change event.
class StateEvent extends FlowEvent {
  /// The name of the provider that changed.
  final String providerName;

  /// The value before the change.
  final Object? previousValue;

  /// The value after the change.
  final Object? newValue;

  const StateEvent({
    required super.id,
    required super.timestamp,
    required this.providerName,
    required this.previousValue,
    required this.newValue,
  }) : super(source: FlowEventSource.state);
}

/// A network request captured by [FlowScopeDioInterceptor].
class NetworkEvent extends FlowEvent {
  /// The full request URL.
  final String url;

  /// The HTTP method (GET, POST, etc).
  final String method;

  /// The HTTP status code of the response.
  final int? statusCode;

  /// The request body.
  final Object? requestBody;

  /// The response body.
  final Object? responseBody;

  /// How long the request took.
  final Duration? duration;

  /// Whether the request succeeded, failed, or is pending.
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

/// A manual log event created via [FlowLogger].
class LogEvent extends FlowEvent {
  /// The log message.
  final String message;

  /// Optional additional data.
  final Object? data;

  /// The severity level of this log.
  final FlowLogLevel level;

  const LogEvent({
    required super.id,
    required super.timestamp,
    required this.message,
    required this.level,
    this.data,
  }) : super(source: FlowEventSource.ui);
}

/// Severity level for [LogEvent].
enum FlowLogLevel {
  /// Informational message.
  info,

  /// Success message.
  success,

  /// Warning message.
  warning,

  /// Error message.
  error,
}

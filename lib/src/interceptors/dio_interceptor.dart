import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../core/event.dart';
import '../core/store.dart';

const _uuid = Uuid();

class FlowScopeDioInterceptor extends Interceptor {
  final _pending = <String, DateTime>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final id = _uuid.v4();
    options.extra['flowscope_id'] = id;
    options.extra['flowscope_start'] = DateTime.now().toIso8601String();

    _pending[id] = DateTime.now();

    FlowStore.instance.add(
      NetworkEvent(
        id: id,
        timestamp: DateTime.now(),
        url: options.uri.toString(),
        method: options.method,
        status: NetworkStatus.pending,
        requestBody: options.data,
      ),
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final id = response.requestOptions.extra['flowscope_id'] as String?;
    final start = _pending.remove(id);
    final duration = start != null ? DateTime.now().difference(start) : null;

    FlowStore.instance.add(
      NetworkEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        url: response.requestOptions.uri.toString(),
        method: response.requestOptions.method,
        status: NetworkStatus.success,
        statusCode: response.statusCode,
        requestBody: response.requestOptions.data,
        responseBody: response.data,
        duration: duration,
      ),
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final id = err.requestOptions.extra['flowscope_id'] as String?;
    final start = _pending.remove(id);
    final duration = start != null ? DateTime.now().difference(start) : null;

    FlowStore.instance.add(
      NetworkEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        url: err.requestOptions.uri.toString(),
        method: err.requestOptions.method,
        status: NetworkStatus.error,
        statusCode: err.response?.statusCode,
        requestBody: err.requestOptions.data,
        responseBody: err.response?.data,
        duration: duration,
      ),
    );

    handler.next(err);
  }
}

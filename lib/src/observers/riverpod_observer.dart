import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/event.dart';
import '../core/store.dart';

const _uuid = Uuid();

base class FlowScopeObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    FlowStore.instance.add(
      StateEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        providerName:
            context.provider.name ?? context.provider.runtimeType.toString(),
        previousValue: previousValue,
        newValue: newValue,
      ),
    );
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    FlowStore.instance.add(
      StateEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        providerName:
            context.provider.name ?? context.provider.runtimeType.toString(),
        previousValue: null,
        newValue: value,
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/event.dart';
import '../core/store.dart';

const _uuid = Uuid();

class FlowScopeObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    FlowStore.instance.add(
      StateEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        providerName: provider.name ?? provider.runtimeType.toString(),
        previousValue: previousValue,
        newValue: newValue,
      ),
    );
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    FlowStore.instance.add(
      StateEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        providerName: provider.name ?? provider.runtimeType.toString(),
        previousValue: null,
        newValue: value,
      ),
    );
  }
}

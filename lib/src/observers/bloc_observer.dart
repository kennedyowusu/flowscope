import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../core/event.dart';
import '../core/store.dart';

const _uuid = Uuid();

class FlowScopeBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    FlowStore.instance.add(
      StateEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        providerName: bloc.runtimeType.toString(),
        previousValue: change.currentState,
        newValue: change.nextState,
        screen: FlowStore.instance.currentScreen,
      ),
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    FlowStore.instance.add(
      LogEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        message: '${bloc.runtimeType} error: $error',
        level: FlowLogLevel.error,
        screen: FlowStore.instance.currentScreen,
      ),
    );
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    FlowStore.instance.add(
      LogEvent(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        message: '${bloc.runtimeType} → ${event.runtimeType}',
        level: FlowLogLevel.info,
        screen: FlowStore.instance.currentScreen,
      ),
    );
  }
}

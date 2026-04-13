# 0.3.2

* Relaxed Dart SDK constraint to support >=3.0.0
* Package now compatible with a wider range of Flutter installations

## 0.3.1

* Fixed FAB position resetting after closing the debug panel
* Fixed overflow in state panel expanded rows for long provider names and values

## 0.3.0

* Added screen-aware logging via FlowScopeRouteObserver
* Every event (state, network, log) is now tagged with the screen it occurred on
* Navigation events (push, pop, replace) appear in the Timeline panel
* Screen name visible on each Timeline event

## 0.2.0

* Added Bloc/Cubit support via FlowScopeBlocObserver
* Bloc state changes, events and errors now appear in State and Timeline panels
* No configuration needed — Bloc observer is set automatically when FlowScope is enabled

## 0.1.2

* Added dartdoc comments to public API
* Added example app for pub.dev
* Improved pub.dev score

## 0.1.1

* Updated flutter_riverpod to ^3.0.0
* Updated flutter_lints to ^6.0.0
* Fixed ProviderObserver API compatibility with Riverpod 3.x
* FlowScopeObserver now uses ProviderObserverContext

## 0.1.0

* Initial release
* In-app floating overlay for Flutter debugging
* Riverpod state inspector with diff view (previous vs new value)
* Event timeline with color coded tags (STATE, NETWORK, LOG, ERROR)
* Dio network interceptor with request/response capture
* FlowLogger for manual event logging
* Draggable floating button
* Clear, Pause, Close overlay controls

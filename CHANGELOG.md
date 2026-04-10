# 0.1.2

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

## 0.2.0

* Added Bloc/Cubit support via FlowScopeBlocObserver
* Bloc state changes, events and errors now appear in State and Timeline panels
* No configuration needed — Bloc observer is set automatically when FlowScope is enabled

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flowscope/flowscope.dart';
import 'package:flutter_riverpod/legacy.dart';

/// A simple counter provider to demonstrate state inspection.
final counterProvider = StateProvider<int>((ref) => 0, name: 'counterProvider');

void main() {
  runApp(
    FlowScope(
      enabled: true,
      child: ProviderScope(
        observers: [FlowScopeObserver()],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowScope Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _makeNetworkCall() async {
    final dio = Dio();
    dio.interceptors.add(FlowScopeDioInterceptor());
    try {
      await dio.get('https://jsonplaceholder.typicode.com/posts/1');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('FlowScope Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $counter', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: const Text('Increment'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _makeNetworkCall,
              child: const Text('Make Network Call'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  FlowLogger.log('Button tapped', level: FlowLogLevel.info),
              child: const Text('Log Event'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/event.dart';
import '../core/store.dart';
import '../overlay/flow_theme.dart';
import '../overlay/tag_badge.dart';
import 'package:intl/intl.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({super.key});

  FlowTag _tagFromEvent(FlowEvent event) {
    return switch (event) {
      StateEvent() => FlowTag.state,
      NetworkEvent e when e.status == NetworkStatus.error => FlowTag.error,
      NetworkEvent() => FlowTag.network,
      LogEvent e when e.level == FlowLogLevel.error => FlowTag.error,
      LogEvent() => FlowTag.log,
    };
  }

  String _messageFromEvent(FlowEvent event) {
    return switch (event) {
      StateEvent e => '${e.providerName} changed → ${e.newValue}',
      NetworkEvent e =>
        '${e.method} ${Uri.parse(e.url).path} ${e.statusCode != null ? '- ${e.statusCode}' : ''}',
      LogEvent e => e.message,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FlowStore.instance,
      builder: (context, _) {
        final events = FlowStore.instance.events;

        if (events.isEmpty) {
          return const _EmptyState(message: 'No events yet');
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final tag = _tagFromEvent(event);
            final message = _messageFromEvent(event);
            final time = DateFormat('HH:mm:ss').format(event.timestamp);

            return _TimelineRow(tag: tag, time: time, message: message);
          },
        );
      },
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final FlowTag tag;
  final String time;
  final String message;

  const _TimelineRow({
    required this.tag,
    required this.time,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: FlowTheme.surfaceElevated, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          Container(width: 3, height: 36, color: FlowTheme.timelineBar(tag)),
          const SizedBox(width: 10),
          Text('[$time]', style: FlowTheme.styleTimestamp),
          const SizedBox(width: 8),
          FlowTagBadge(tag: tag),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: FlowTheme.styleProviderName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: FlowTheme.styleLabel));
  }
}

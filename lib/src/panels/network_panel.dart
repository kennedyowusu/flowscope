import 'package:flutter/material.dart';
import '../core/event.dart';
import '../core/store.dart';
import '../overlay/flow_theme.dart';
import 'package:intl/intl.dart';

class NetworkPanel extends StatelessWidget {
  const NetworkPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FlowStore.instance,
      builder: (context, _) {
        final events = FlowStore.instance.networkEvents
            .where((e) => e.status != NetworkStatus.pending)
            .toList();

        if (events.isEmpty) {
          return const _EmptyState();
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return _NetworkRow(event: events[index], index: index + 1);
          },
        );
      },
    );
  }
}

class _NetworkRow extends StatefulWidget {
  final NetworkEvent event;
  final int index;

  const _NetworkRow({required this.event, required this.index});

  @override
  State<_NetworkRow> createState() => _NetworkRowState();
}

class _NetworkRowState extends State<_NetworkRow> {
  bool _expanded = false;

  Color get _statusColor {
    final code = widget.event.statusCode ?? 0;
    if (code >= 200 && code < 300) return FlowTheme.green;
    if (code >= 400) return FlowTheme.red;
    return FlowTheme.yellow;
  }

  Color get _methodColor {
    return switch (widget.event.method.toUpperCase()) {
      'GET' => FlowTheme.cyan,
      'POST' => FlowTheme.green,
      'PUT' || 'PATCH' => FlowTheme.yellow,
      'DELETE' => FlowTheme.red,
      _ => FlowTheme.textSecondary,
    };
  }

  String get _duration {
    if (widget.event.duration == null) return '';
    final ms = widget.event.duration!.inMilliseconds;
    return '${ms}ms';
  }

  String get _path => Uri.parse(widget.event.url).path;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        decoration: BoxDecoration(
          color: _expanded ? FlowTheme.surfaceElevated : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: FlowTheme.surfaceElevated, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Text(
                    widget.index.toString().padLeft(2, '0'),
                    style: FlowTheme.styleTimestamp,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    color: _methodColor.withValues(alpha: 0.15),
                    child: Text(
                      widget.event.method.toUpperCase(),
                      style: TextStyle(
                        fontFamily: FlowTheme.fontMono,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _methodColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _path,
                      style: FlowTheme.styleProviderName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    widget.event.statusCode?.toString() ?? '---',
                    style: FlowTheme.styleValue.copyWith(color: _statusColor),
                  ),
                  const SizedBox(width: 8),
                  Text(_duration, style: FlowTheme.styleTimestamp),
                ],
              ),
            ),
            if (_expanded) _ExpandedDetail(event: widget.event),
          ],
        ),
      ),
    );
  }
}

class _ExpandedDetail extends StatelessWidget {
  final NetworkEvent event;

  const _ExpandedDetail({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.requestBody != null) ...[
            _SectionLabel(label: 'REQUEST_BODY'),
            const SizedBox(height: 6),
            _CodeBlock(content: event.requestBody.toString()),
            const SizedBox(height: 10),
          ],
          if (event.responseBody != null) ...[
            _SectionLabel(label: 'RESPONSE_BODY'),
            const SizedBox(height: 6),
            _CodeBlock(content: event.responseBody.toString()),
            const SizedBox(height: 10),
          ],
          _SectionLabel(label: 'TIMESTAMP'),
          const SizedBox(height: 6),
          Text(
            DateFormat('HH:mm:ss.SSS').format(event.timestamp),
            style: FlowTheme.styleTimestamp,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: FlowTheme.styleLabel);
  }
}

class _CodeBlock extends StatelessWidget {
  final String content;

  const _CodeBlock({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: FlowTheme.background,
      child: Text(
        content,
        style: const TextStyle(
          fontFamily: FlowTheme.fontMono,
          fontSize: 11,
          color: FlowTheme.green,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No network requests yet', style: FlowTheme.styleLabel),
    );
  }
}

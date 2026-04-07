import 'package:flutter/material.dart';
import '../core/event.dart';
import '../core/store.dart';
import '../overlay/flow_theme.dart';
import 'package:intl/intl.dart';

class StatePanel extends StatelessWidget {
  const StatePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FlowStore.instance,
      builder: (context, _) {
        final events = FlowStore.instance.stateEvents;

        if (events.isEmpty) {
          return const _EmptyState();
        }

        // deduplicate — show only latest state per provider
        final latestByProvider = <String, StateEvent>{};
        for (final event in events) {
          latestByProvider[event.providerName] ??= event;
        }

        final providers = latestByProvider.values.toList();

        return ListView.builder(
          itemCount: providers.length,
          itemBuilder: (context, index) {
            return _StateRow(event: providers[index]);
          },
        );
      },
    );
  }
}

class _StateRow extends StatefulWidget {
  final StateEvent event;

  const _StateRow({required this.event});

  @override
  State<_StateRow> createState() => _StateRowState();
}

class _StateRowState extends State<_StateRow> {
  bool _expanded = false;

  Color _valueColor(Object? value) {
    if (value == null) return FlowTheme.textSecondary;
    if (value is bool) return value ? FlowTheme.green : FlowTheme.red;
    if (value is num) return FlowTheme.cyan;
    final str = value.toString().toLowerCase();
    if (str.contains('error') || str.contains('fail')) return FlowTheme.red;
    if (str.contains('success') || str.contains('authenticated')) {
      return FlowTheme.green;
    }
    if (str == 'null' || str == 'disabled') return FlowTheme.red;
    return FlowTheme.cyan;
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm:ss').format(widget.event.timestamp);
    final valueColor = _valueColor(widget.event.newValue);

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
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: FlowTheme.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 3,
                    child: Text(
                      widget.event.providerName,
                      style: FlowTheme.styleProviderName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 2,
                    child: Text(
                      widget.event.newValue?.toString() ?? 'null',
                      style: FlowTheme.styleValue.copyWith(color: valueColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(time, style: FlowTheme.styleTimestamp),
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
  final StateEvent event;

  const _ExpandedDetail({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(36, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.previousValue != null) ...[
            Row(
              children: [
                const Text('- ', style: TextStyle(color: FlowTheme.red)),
                Text(
                  event.previousValue.toString(),
                  style: const TextStyle(
                    fontFamily: FlowTheme.fontMono,
                    fontSize: 12,
                    color: FlowTheme.red,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          Row(
            children: [
              const Text('+ ', style: TextStyle(color: FlowTheme.green)),
              Text(
                event.newValue?.toString() ?? 'null',
                style: const TextStyle(
                  fontFamily: FlowTheme.fontMono,
                  fontSize: 12,
                  color: FlowTheme.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: FlowTheme.cyan.withValues(alpha: 0.3)),
            ),
            child: Text(
              'REASON: ASYNC_DATA_FETCH',
              style: TextStyle(
                fontFamily: FlowTheme.fontMono,
                fontSize: 10,
                color: FlowTheme.cyan.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No state changes yet', style: FlowTheme.styleLabel),
    );
  }
}

import 'package:flutter/material.dart';
import '../panels/state_panel.dart';
import '../panels/timeline_panel.dart';
import '../panels/network_panel.dart';
import '../core/store.dart';
import 'flow_theme.dart';
import 'action_bar.dart';

class FlowDebugPanel extends StatefulWidget {
  final VoidCallback onClose;

  const FlowDebugPanel({super.key, required this.onClose});

  @override
  State<FlowDebugPanel> createState() => _FlowDebugPanelState();
}

class _FlowDebugPanelState extends State<FlowDebugPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.72;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: FlowTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            _buildHandle(),
            _buildHeader(),
            const Divider(
              height: 1,
              thickness: 1,
              color: FlowTheme.surfaceElevated,
            ),
            _buildTabs(),
            Expanded(child: _buildTabViews()),
            ListenableBuilder(
              listenable: FlowStore.instance,
              builder: (context, _) {
                return FlowActionBar(
                  isPaused: FlowStore.instance.isPaused,
                  onClear: FlowStore.instance.clear,
                  onPause: () {
                    FlowStore.instance.isPaused
                        ? FlowStore.instance.resume()
                        : FlowStore.instance.pause();
                  },
                  onClose: widget.onClose,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Container(
        width: 36,
        height: 3,
        decoration: BoxDecoration(
          color: FlowTheme.textMuted,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          const Icon(
            Icons.track_changes_rounded,
            color: FlowTheme.cyan,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text('FLOWSCOPE', style: FlowTheme.styleHeader),
          const Spacer(),
          ListenableBuilder(
            listenable: FlowStore.instance,
            builder: (context, _) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: FlowStore.instance.isPaused
                      ? FlowTheme.yellow
                      : FlowTheme.green,
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.settings_outlined,
            color: FlowTheme.textSecondary,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: FlowTheme.surfaceElevated, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: FlowTheme.cyan,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: FlowTheme.cyan,
        unselectedLabelColor: FlowTheme.textSecondary,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontFamily: FlowTheme.fontMono,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: FlowTheme.fontMono,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        indicator: const BoxDecoration(
          color: FlowTheme.surfaceElevated,
          border: Border(bottom: BorderSide(color: FlowTheme.cyan, width: 2)),
        ),
        tabs: const [
          Tab(text: 'STATE'),
          Tab(text: 'TIMELINE'),
          Tab(text: 'NETWORK'),
        ],
      ),
    );
  }

  Widget _buildTabViews() {
    return TabBarView(
      controller: _tabController,
      children: const [StatePanel(), TimelinePanel(), NetworkPanel()],
    );
  }
}

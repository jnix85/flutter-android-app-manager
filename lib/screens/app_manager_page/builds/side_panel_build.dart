part of '../app_manager_page.dart';

extension _SidePanelBuild on _AppManagerPageState {
  Widget _buildResizeHandle(BoxConstraints constraints) {
    final colors = AppColors.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) => _rebuild(() {
          _panelWidth -= details.delta.dx;
          _panelWidth = _panelWidth.clamp(250, constraints.maxWidth * 0.5);
          _isPanelVisible = _panelWidth > 50;
        }),
        child: Container(
          width: 4,
          color: colors.surfaceVariant.withOpacity(0.8),
          child: Center(
            child: Container(
              width: 2,
              height: 40,
              color: colors.foregroundMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidePanel(BoxConstraints constraints) {
    final colors = AppColors.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isPanelVisible ? _panelWidth : 0,
      constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.5),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.9),
        border: Border.all(color: colors.foreground.withOpacity(0.1)),
      ),
      child: _isPanelVisible
          ? SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ValueListenableBuilder<String>(
                      valueListenable: Localization.languageNotifier,
                      builder: (context, languageCode, child) {
                        final c = AppColors.of(context);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: c.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      _buildActionButton(
                                        label: Localization.translate('reload'),
                                        icon: Icons.refresh,
                                        tooltip: Localization.translate('reload_tooltip'),
                                        onPressed: _loadAppsFromDevice,
                                        delay: 300,
                                      ),
                                      _buildActionButton(
                                        label: Localization.translate('device'),
                                        icon: Icons.usb,
                                        tooltip: Localization.translate('device_tooltip'),
                                        onPressed: () async {
                                          if (await AdbService.selectDevice(
                                              context,
                                              showSelector: true,
                                              loadAppsCallback: _loadAppsFromDevice)) {
                                            _rebuild(() {
                                              _showIcons = false;
                                              _iconsReadyNotifier.value = false;
                                            });
                                          }
                                        },
                                        delay: 350,
                                      ),
                                      _buildActionButton(
                                        label: Localization.translate('log'),
                                        icon: Icons.article,
                                        tooltip: Localization.translate('log_tooltip'),
                                        onPressed: () => AdbService.lastLog != null
                                            ? Alert.showLog(context, AdbService.lastLog!)
                                            : null,
                                        delay: 400,
                                      ),
                                      _buildActionButton(
                                        label: Localization.translate('browse'),
                                        icon: Icons.add_circle,
                                        tooltip: Localization.translate('browse_tooltip'),
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (_) => ReposOverlay(
                                              refreshUI: () => _rebuild(() {})),
                                        ),
                                        delay: 450,
                                      ),
                                      _buildActionButton(
                                        label: Localization.translate('settings'),
                                        icon: Icons.settings,
                                        tooltip: Localization.translate('settings_tooltip'),
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (_) => ConfigOverlay(
                                            onConnect: _loadAppsFromDevice,
                                            refreshUI: () => _rebuild(() {}),
                                            onAlwaysShowIconsChanged: _setShowIcons,
                                          ),
                                        ),
                                        delay: 500,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  FadeIn(
                                    duration: const Duration(milliseconds: 550),
                                    child: ViewSelector(
                                      currentMode: _viewMode,
                                      onModeChanged: (mode) {
                                        _rebuild(() => _viewMode = mode);
                                        if (mode == ViewMode.mosaic &&
                                            !_showIcons) {
                                          _setShowIcons(true);
                                        }
                                      },
                                      showIcons: _showIcons,
                                      onShowIcons: _setShowIcons,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FadeIn(
                                        duration: const Duration(milliseconds: 600),
                                        child: Tooltip(
                                          message: Localization.translate('import_tooltip'),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minWidth: 80, maxWidth: 100),
                                            child: ElevatedButton(
                                              onPressed: _importAppActions,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: c.surfaceVariant,
                                                foregroundColor: c.foreground,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(8)),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 8),
                                              ),
                                              child: Text(
                                                  Localization.translate('import'),
                                                  style: const TextStyle(fontSize: 12),
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      FadeIn(
                                        duration: const Duration(milliseconds: 650),
                                        child: Tooltip(
                                          message: Localization.translate('export_tooltip'),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minWidth: 80, maxWidth: 100),
                                            child: ElevatedButton(
                                              onPressed: _exportAppActions,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: c.surfaceVariant,
                                                foregroundColor: c.foreground,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(8)),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 8),
                                              ),
                                              child: Text(
                                                  Localization.translate('export'),
                                                  style: const TextStyle(fontSize: 12),
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            FadeIn(
                              duration: const Duration(milliseconds: 300),
                              child: Center(
                                  child: ApplyButton(
                                      hintKey: _applyHintKey,
                                      onPressed: _applyChanges)),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: FadeIn(
                                duration: const Duration(milliseconds: 500),
                                child: DataTable(
                                  dataRowHeight: 32,
                                  headingRowHeight: 36,
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                          Localization.translate('action'),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    DataColumn(
                                        label: Text(
                                          Localization.translate('count'),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  ],
                                  rows: [
                                    DataRow(cells: [
                                      DataCell(Text(
                                          Localization.translate('activate'),
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          ManagerService.activateCount.toString(),
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text(
                                          Localization.translate('install'),
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          ManagerService.installCount.toString(),
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text(
                                          Localization.translate('uninstall'),
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          ManagerService.uninstallCount.toString(),
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text(
                                          Localization.translate('deactivate'),
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          ManagerService.deactivateCount.toString(),
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text(
                                          Localization.translate('total'),
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          (ManagerService.activateCount +
                                                  ManagerService.installCount +
                                                  ManagerService.uninstallCount +
                                                  ManagerService.deactivateCount)
                                              .toString(),
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

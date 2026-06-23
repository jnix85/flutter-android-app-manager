part of '../app_manager_page.dart';

extension _SearchBarBuild on _AppManagerPageState {
  Widget _buildSearchPanel() {
    final colors = AppColors.of(context);
    return Positioned(
      top: 8,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeIn(
              duration: const Duration(milliseconds: 300),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: Localization.translate('search_hint'),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
                style: TextStyle(color: colors.foreground, fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: Localization.languageNotifier,
              builder: (context, languageCode, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: _buildBottomDropdown(
                          label: Localization.translate('state_label'),
                          value: _stateFilter,
                          items: stateItems,
                          onChanged: (value) =>
                              _rebuild(() => _stateFilter = value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: _buildBottomDropdown(
                          label: Localization.translate('system_label'),
                          value: _systemFilter,
                          items: systemItems,
                          onChanged: (value) =>
                              _rebuild(() => _systemFilter = value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: _buildBottomDropdown(
                          label: Localization.translate('check_label'),
                          value: _checkFilter,
                          items: checkItems,
                          onChanged: (value) =>
                              _rebuild(() => _checkFilter = value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildSortIconButton(),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final c = AppColors.of(context);
                final availableWidth = constraints.maxWidth * 0.8;
                return FadeIn(
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: availableWidth, minHeight: 36),
                      child: Container(
                        decoration: BoxDecoration(
                          color: c.surface,
                          border: Border.all(color: c.foreground.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextButton(
                                onPressed: () {
                                  _rebuild(() {
                                    for (var app in _filteredData) {
                                      app['isChecked'] = true;
                                    }
                                    ManagerService.updateActionCounters();
                                    _triggerApplyHint();
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: c.foreground,
                                  backgroundColor: c.buttonSurface,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  Localization.translate('check_all'),
                                  style: TextStyle(fontSize: 12, color: c.foreground),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: c.foreground.withOpacity(0.2),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextButton(
                                onPressed: () {
                                  _rebuild(() {
                                    for (var app in _filteredData) {
                                      app['isChecked'] = false;
                                    }
                                    ManagerService.updateActionCounters();
                                    _triggerApplyHint();
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: c.foreground,
                                  backgroundColor: c.buttonSurface,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text(
                                  Localization.translate('uncheck_all'),
                                  style: TextStyle(fontSize: 12, color: c.foreground),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: c.foreground.withOpacity(0.2),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextButton(
                                onPressed: () {
                                  _rebuild(() {
                                    for (var app in _filteredData) {
                                      app['isChecked'] = app['state'] == 1;
                                    }
                                    ManagerService.updateActionCounters();
                                    _triggerApplyHint();
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: c.foreground,
                                  backgroundColor: c.buttonSurface,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  Localization.translate('restore_all'),
                                  style: TextStyle(fontSize: 12, color: c.foreground),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

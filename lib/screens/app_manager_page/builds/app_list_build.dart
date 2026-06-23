part of '../app_manager_page.dart';

extension _AppListBuild on _AppManagerPageState {
  Widget _buildAppList() =>
  ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: _filteredData.length,
    itemBuilder: (context, index) {
      final app = _filteredData[index];
      final isExpanded = app['isExpanded'] ?? false;

      return FadeIn(
        duration: const Duration(milliseconds: 150),
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Column(
            children: [
              ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppCheckbox(
                      app: app,
                      onChanged: () {
                        _rebuild(() {
                          ManagerService.updateActionCounters();
                          _triggerApplyHint();
                        });
                      },
                      index: index,
                      hintKey: index == 0 ? _firstCheckboxHintKey : null,
                    ),
                    if (_showIcons && ManagerService.iconsLoaded) ...[
                      const SizedBox(width: 6),
                      _appIconWidget(app, 40),
                    ],
                  ],
                ),
                title: Text(
                  app['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  app['package'],
                  style: TextStyle(
                    color: AppColors.of(context).foregroundMuted,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: TextButton.icon(
                  onPressed: () => _rebuild(() => app['isExpanded'] = !isExpanded),
                  icon: Icon(
                    isExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  label: Text(
                    isExpanded
                        ? Localization.translate('hide')
                        : Localization.translate('info'),
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
              if (isExpanded)
                FadeIn(
                  duration: const Duration(milliseconds: 150),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(100),
                            1: FlexColumnWidth(),
                            2: FixedColumnWidth(70),
                          },
                          children: [
                            _buildInfoRow(Localization.translate('name'), app['name']),
                            _buildInfoRow(Localization.translate('id'), app['id']),
                            _buildInfoRow(Localization.translate('package'), app['package']),
                            _buildInfoRow(Localization.translate('type'),
                                app['isSystem']
                                    ? Localization.translate('system')
                                    : Localization.translate('user')),
                            _buildInfoRow(Localization.translate('path'), app['path']),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

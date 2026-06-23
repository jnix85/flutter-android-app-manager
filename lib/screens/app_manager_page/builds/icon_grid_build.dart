part of '../app_manager_page.dart';

extension _IconGridBuild on _AppManagerPageState {
  Widget _buildIconGrid(double availableWidth) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 0.72,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredData.length,
      itemBuilder: (context, index) {
        final app = _filteredData[index];
        final iconPath = app['iconPath'] as String?;
        final showRealIcon = _showIcons &&
            ManagerService.iconsLoaded &&
            iconPath != null &&
            !iconPath.startsWith('assets/');

        return FadeIn(
          duration: const Duration(milliseconds: 100),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: app['isChecked'],
                    onChanged: (value) => _rebuild(() {
                      app['isChecked'] = value;
                      ManagerService.updateActionCounters();
                      _triggerApplyHint();
                    }),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    activeColor: Theme.of(context).primaryColor,
                    checkColor: AppColors.of(context).foreground,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                  ),
                  const SizedBox(height: 4),
                  MouseRegion(
                    onEnter: showRealIcon
                        ? (_) => _rebuild(() => app['isHovering'] = true)
                        : null,
                    onExit: showRealIcon
                        ? (_) => _rebuild(() => app['isHovering'] = false)
                        : null,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _appIconWidget(app, 56),
                        if (showRealIcon)
                          AnimatedOpacity(
                            opacity: app['isHovering'] == true ? 1 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 56,
                                height: 56,
                                color: AppColors.of(context).foreground.withOpacity(0.15),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.download_rounded, color: AppColors.of(context).foreground, size: 28),
                                    tooltip: Localization.translate('export_icon'),
                                    onPressed: () async => await FileManager.exportAppIcon(context, app['package'], app['iconPath']),
                                    style: IconButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        app['name'],
                        style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.25,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

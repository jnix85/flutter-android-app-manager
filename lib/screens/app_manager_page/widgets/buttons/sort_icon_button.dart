part of '../../app_manager_page.dart';

extension _SortIconButtonBuild on _AppManagerPageState {
  Widget _buildSortIconButton() {
    final isCustomSort = _sortBy != 'name';
    final colors = AppColors.of(context);
    return Tooltip(
      message: Localization.translate('sort_label'),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) {
              final c = AppColors.of(context);
              return Material(
                color: c.surface.withOpacity(0.9),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 4,
                      width: 40,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: c.foregroundMuted,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    ...sortItems.map(
                      (item) => ListTile(
                        title: Text(
                          Localization.translate(item['text']!),
                          style: TextStyle(
                            color: item['value'] == _sortBy
                                ? Theme.of(context).primaryColor
                                : c.foreground,
                            fontWeight: item['value'] == _sortBy
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        trailing: item['value'] == _sortBy
                            ? Icon(Icons.check,
                                color: Theme.of(context).primaryColor, size: 20)
                            : null,
                        onTap: () {
                          _rebuild(() => _sortBy = item['value']!);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCustomSort
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : colors.foreground.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCustomSort
                  ? Theme.of(context).primaryColor
                  : colors.foreground.withOpacity(0.2),
            ),
          ),
          child: Icon(
            Icons.sort,
            color: isCustomSort ? Theme.of(context).primaryColor : colors.foregroundMuted,
            size: 18,
          ),
        ),
      ),
    );
  }
}

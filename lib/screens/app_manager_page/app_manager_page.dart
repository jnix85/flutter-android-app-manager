import 'dart:io';
import 'dart:async';
import 'package:android_app_manager/services/manager.dart';
import 'package:android_app_manager/utils/file_manager.dart';
import 'package:android_app_manager/utils/config.dart';
import 'package:android_app_manager/utils/url.dart';
import 'package:android_app_manager/services/adb.dart';
import 'package:android_app_manager/overlays/alert.dart';
import 'package:android_app_manager/overlays/config.dart';
import 'package:android_app_manager/overlays/repo.dart';
import 'package:android_app_manager/overlays/tips.dart';
import 'package:android_app_manager/utils/localization.dart';
import 'package:android_app_manager/widgets/buttons/apply_button.dart';
import 'package:android_app_manager/widgets/checkbox.dart';
import 'package:android_app_manager/widgets/loading.dart';
import 'package:android_app_manager/widgets/view_selector.dart';
import 'package:android_app_manager/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';

part 'builds/app_bar_build.dart';
part 'builds/search_bar_build.dart';
part 'builds/side_panel_build.dart';
part 'builds/app_list_build.dart';
part 'builds/icon_grid_build.dart';
part 'widgets/buttons/action_button.dart';
part 'widgets/buttons/bottom_dropdown.dart';
part 'widgets/buttons/sort_icon_button.dart';
part 'widgets/info_row.dart';

const defaultIconPath = 'assets/images/default_app_icon.png';
late final String appSupportDir;
late final String iconsDirPath;

class AppManagerPage extends StatefulWidget {
  const AppManagerPage({super.key});

  @override
  _AppManagerPageState createState() => _AppManagerPageState();
}

class _AppManagerPageState extends State<AppManagerPage> {
  final _searchController = TextEditingController();
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _iconsReadyNotifier = ValueNotifier(false);
  final Map<String, Image> _iconCache = {};
  final GlobalKey<HintMessageState> _applyHintKey = GlobalKey<HintMessageState>();
  final GlobalKey<HintMessageState> _firstCheckboxHintKey = GlobalKey<HintMessageState>();
  
  String? _stateFilter = 'all';
  String? _systemFilter = 'all';
  String? _checkFilter = 'all';
  String _sortBy = 'name';
  double _panelWidth = 300;
  bool _isPanelVisible = true;
  ViewMode _viewMode = ViewMode.list;
  bool _showIcons = false;
  Timer? _debounceTimer;

  final List<Map<String, String>> stateItems = [
    {'value': 'all', 'text': 'all_apps'},
    {'value': '1', 'text': 'enabled'},
    {'value': '0', 'text': 'disabled'},
    {'value': '-1', 'text': 'uninstalled'},
  ];

  final List<Map<String, String>> systemItems = [
    {'value': 'all', 'text': 'system_user'},
    {'value': '1', 'text': 'system'},
    {'value': '0', 'text': 'user'},
  ];

  final List<Map<String, String>> checkItems = [
    {'value': 'all', 'text': 'any'},
    {'value': '1', 'text': 'checked'},
    {'value': '0', 'text': 'unchecked'},
    {'value': 'applicable', 'text': 'applicable'},
  ];

  final List<Map<String, String>> sortItems = [
    {'value': 'name', 'text': 'sort_name_asc'},
    {'value': 'name_desc', 'text': 'sort_name_desc'},
    {'value': 'package', 'text': 'sort_package'},
    {'value': 'state', 'text': 'sort_state'},
    {'value': 'type', 'text': 'sort_type'},
  ];

  List<Map<String, dynamic>> get _filteredData {
    final list = ManagerService.apps.values.where((item) {
      final searchLower = _searchController.text.toLowerCase();
      final matchesState = _stateFilter == 'all' || (item['state']?.toString() == _stateFilter);
      final matchesSystem = _systemFilter == 'all' || (item['isSystem'] == (_systemFilter == '1'));
      final state = item['state'] as int?;
      final isChecked = item['isChecked'] as bool?;
      final action = item['action'] as String?;

      final matchesSearch = (item['name']?.toString()
                  .toLowerCase()
                  .contains(searchLower)
              ?? false)
          || (item['package']?.toString()
                  .toLowerCase()
                  .contains(searchLower)
              ?? false);
      final matchesCheck = _checkFilter == 'all'
          ? true
          : _checkFilter == '1'
              ? (item['isChecked'] == true)
              : _checkFilter == '0'
                  ? (item['isChecked'] == false)
                  : (state != null && isChecked != null) &&
                      (action == 'install-disable' ||
                          (state > 0 && isChecked == false) ||
                          (state == 0 && isChecked == true) ||
                          (state < 0 && isChecked == true));
      return matchesSearch && matchesState && matchesSystem && matchesCheck;
    }).toList();
    
    list.sort((a, b) {
      switch (_sortBy) {
        case 'name_desc':
          return (b['name']?.toString() ?? '')
              .toLowerCase()
              .compareTo((a['name']?.toString() ?? '').toLowerCase());
        case 'package':
          return (a['package']?.toString() ?? '')
              .toLowerCase()
              .compareTo((b['package']?.toString() ?? '').toLowerCase());
        case 'state':
          return (b['state'] as int? ?? 0).compareTo(a['state'] as int? ?? 0);
        case 'type':
          final aVal = a['isSystem'] == true ? 1 : 0;
          final bVal = b['isSystem'] == true ? 1 : 0;
          if (bVal != aVal) return bVal.compareTo(aVal);
          return (a['name']?.toString() ?? '')
              .toLowerCase()
              .compareTo((b['name']?.toString() ?? '').toLowerCase());
        default:
          return (a['name']?.toString() ?? '')
              .toLowerCase()
              .compareTo((b['name']?.toString() ?? '').toLowerCase());
      }
    });
    return list;
  }

  void _copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(Localization.translate('copied_to_clipboard'),
            overflow: TextOverflow.ellipsis),
      ),
    );
  }

  void _triggerApplyHint() {
    _applyHintKey.currentState?.showHint();
  }

  void _rebuild(VoidCallback fn) => setState(fn);

  void _onLanguageChanged() {
    setState(() {
      _stateFilter = _translateFilter(_stateFilter, stateItems);
      _systemFilter = _translateFilter(_systemFilter, systemItems);
      _checkFilter = _translateFilter(_checkFilter, checkItems);
    });
  }

  String _translateFilter(String? currentValue, List<Map<String, String>> items) {
    if (currentValue == null) return items[0]['value']!;
    for (var item in items) {
      if (item['value'] == currentValue) return currentValue;
    }
    return items[0]['value']!;
  }

  @override
  void initState() {
    super.initState();
    _showIcons = ConfigUtils.alwaysShowIcons;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadAppsFromDevice();
    });
    _searchController.addListener(() => setState(() {}));
    Localization.languageNotifier.addListener(_onLanguageChanged);
  }

  Future<void> _setShowIcons(bool newValue) async {
    _iconsReadyNotifier.value = ManagerService.iconsLoaded;
    if (newValue && !ManagerService.iconsLoaded && !await _loadAppIcons())
      return;
    if (mounted) setState(() => _showIcons = newValue);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _isLoadingNotifier.dispose();
    _iconsReadyNotifier.dispose();
    _searchController.dispose();
    _iconCache.clear();
    Localization.languageNotifier.removeListener(_onLanguageChanged);
    super.dispose();
  }

  Widget _appIconWidget(Map<String, dynamic> app, double size) {
    final iconPath = app['iconPath'] as String?;
    Widget image;
    if (_showIcons && ManagerService.iconsLoaded && iconPath != null && !iconPath.startsWith('assets/') && File(iconPath).existsSync()) {
      final String path = iconPath;
      image = _iconCache.putIfAbsent(
        path,
        () => Image.file(
          File(path),
          fit: BoxFit.cover,
          cacheWidth: 112,
          gaplessPlayback: true,
        ),
      );
    } else {
      image = Image.asset(defaultIconPath, fit: BoxFit.cover);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: SizedBox(width: size, height: size, child: image),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.of(context).background,
        appBar: _buildAppBar(),
        body: LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 160),
                      child: Column(
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _isLoadingNotifier,
                            builder: (context, isLoading, child) => Loading(
                              isLoadingApps: isLoading,
                              loadIcons: _showIcons,
                              iconsReady: _iconsReadyNotifier.value,
                              isFilteredDataEmpty: _filteredData.isEmpty,
                            ),
                          ),
                          Expanded(
                            child: _viewMode == ViewMode.mosaic
                                ? _buildIconGrid(constraints.maxWidth)
                                : _buildAppList(),
                          ),
                        ],
                      ),
                    ),
                    _buildSearchPanel(),
                  ],
                ),
              ),
              _buildResizeHandle(constraints),
              _buildSidePanel(constraints),
            ],
          ),
        ),
      );

  Future<void> _loadAppsFromDevice() async {
    _isLoadingNotifier.value = true;
    _iconsReadyNotifier.value = false;
    _iconCache.clear();
    await ManagerService.loadAppsFromDevice(context, refreshUI: () {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _firstCheckboxHintKey.currentState?.showHint();
      });
    });
    if (_showIcons) await _loadAppIcons();
    _isLoadingNotifier.value = false;
    setState(() {});
  }

  Future<bool> _loadAppIcons() async {
    final success = await ManagerService.loadAppIcons(context, iconsDirPath, defaultIconPath);
    if (success) {
      for (var app in ManagerService.apps.values) {
        final iconPath = app['iconPath'] as String?;
        if (iconPath == null || iconPath.startsWith('assets/')) continue;
        _iconCache.putIfAbsent(
          iconPath,
          () => Image.file(
            File(iconPath),
            fit: BoxFit.cover,
            cacheWidth: 112,
            gaplessPlayback: true,
          ),
        );
      }
    }
    _iconsReadyNotifier.value = success;
    _isLoadingNotifier.value = false;
    return success;
  }

  Future<void> _importAppActions() async {
    await FileManager.importAppActions(context);
    setState(() {});
  }

  Future<void> _exportAppActions() async => await FileManager.exportAppActions(context);
  
  Future<void> _applyChanges() async {
    await ManagerService.applyChanges(context);
    setState(() {});
  }
}

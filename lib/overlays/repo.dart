import 'dart:async';
import 'package:flutter/material.dart';
import 'package:android_app_manager/api/repo.dart';
import 'package:android_app_manager/utils/file_manager.dart';
import 'package:android_app_manager/overlays/alert.dart';
import 'package:android_app_manager/utils/url.dart';
import 'package:animate_do/animate_do.dart';
import 'package:android_app_manager/utils/localization.dart';
import 'package:android_app_manager/utils/app_theme.dart';

class ReposOverlay extends StatefulWidget {
  final VoidCallback? refreshUI;

  const ReposOverlay({super.key, this.refreshUI});

  @override
  State<ReposOverlay> createState() => _ReposOverlayState();
}

class _ReposOverlayState extends State<ReposOverlay> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _repos = [];
  List<Map<String, dynamic>> _filteredRepos = [];
  bool _isLoading = true;
  static List<Map<String, dynamic>>? _cachedRepos;

  @override
  void initState() {
    super.initState();
    _loadRepos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRepos({bool forceRefresh = false}) async {
    setState(() => _isLoading = true);
    try {
      if (_cachedRepos != null && !forceRefresh) {
        setState(() {
          _repos = _cachedRepos!;
          _filteredRepos = [..._repos];
          _isLoading = false;
        });
      } else {
        final repos = await RepoRequest.fetchRepos();
        setState(() {
          _cachedRepos = repos;
          _repos = repos;
          _filteredRepos = [..._repos];
          _isLoading = false;
        });
      }
    } catch (e) {
      _showError('${Localization.translate('error_fetching_repos')} $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchRepos() async {
    final query = _searchController.text.trim();
    setState(() => _isLoading = true);
    try {
      if (query.isEmpty) {
        setState(() {
          _filteredRepos = [..._repos];
          _isLoading = false;
        });
      } else {
        final repos = await RepoRequest.searchRepos(query);
        setState(() {
          _filteredRepos = repos;
          _isLoading = false;
        });
      }
    } catch (e) {
      _showError('${Localization.translate('error_searching_repos')} $e');
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    Alert.showWarning(context, message);
  }

  Future<void> _applyRepo(String repoName) async {
    setState(() => _isLoading = true);
    try {
      final jsonString = await RepoRequest.fetchAppsJson(repoName);
      await FileManager.importJsonString(context, jsonString);
      widget.refreshUI?.call();
      Navigator.of(context).pop();
    } catch (e) {
      _showError('${Localization.translate('error_importing_repo')} $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.maxWidth;
        final parentHeight = constraints.maxHeight;
        return AlertDialog(
          backgroundColor: AppColors.of(context).background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: EdgeInsets.symmetric(
            horizontal: parentWidth * 0.1,
            vertical: parentHeight * 0.1,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FadeIn(
                        duration: const Duration(milliseconds: 300),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: Localization.translate('search_repos_hint'),
                          ),
                          style: TextStyle(color: AppColors.of(context).foreground),
                          onSubmitted: (_) => _searchRepos(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FadeIn(
                      duration: const Duration(milliseconds: 300),
                      child: Tooltip(
                        message: Localization.translate('search_repos_tooltip'),
                        child: IconButton(
                          icon: Icon(Icons.search, color: AppColors.of(context).foreground),
                          onPressed: _isLoading ? null : _searchRepos,
                        ),
                      ),
                    ),
                    FadeIn(
                      duration: const Duration(milliseconds: 300),
                      child: Tooltip(
                        message: Localization.translate('reload_repos_tooltip'),
                        child: IconButton(
                          icon: Icon(Icons.refresh, color: AppColors.of(context).foreground),
                          onPressed: _isLoading ? null : () => _loadRepos(forceRefresh: true),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: parentWidth * 0.8,
                  height: parentHeight * 0.8,
                  child: _isLoading
                      ? Center(
                          child: FadeIn(
                            duration: const Duration(milliseconds: 300),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: _filteredRepos.map((repo) {
                              return FadeIn(
                                duration: const Duration(milliseconds: 300),
                                child: Card(
                                  elevation: 0,
                                  color: AppColors.of(context).surface,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      repo['name']?.toString() ?? Localization.translate('unknown_repo_name'),
                                                      style: TextStyle(color: AppColors.of(context).foreground, fontWeight: FontWeight.bold),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.of(context).buttonSurfaceVariant,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      repo['owner']['type'] == 'Organization' && repo['owner']['login'] == 'AppManager-Repo'
                                                          ? 'AppManager'
                                                          : repo['owner']['type'] == 'User' && repo['owner']['login'] == 'AppManager'
                                                              ? Localization.translate('unknown_owner')
                                                              : repo['owner']['login']?.toString() ?? Localization.translate('unknown_owner'),
                                                      style: TextStyle(color: AppColors.of(context).foreground, fontSize: 12),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Icon(Icons.star, size: 16, color: Colors.yellow),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    (repo['stargazers_count'] as int?)?.toString() ?? 'N/A',
                                                    style: TextStyle(color: AppColors.of(context).foreground, fontSize: 12),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  FadeIn(
                                                    duration: const Duration(milliseconds: 300),
                                                    child: IconButton(
                                                      icon: Icon(Icons.code, color: AppColors.of(context).foreground, size: 18),
                                                      tooltip: Localization.translate('open_github_tooltip'),
                                                      padding: EdgeInsets.zero,
                                                      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                                      onPressed: () => UrlUtils.launchUrlOrShow(context, repo['html_url']?.toString() ?? ''),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                repo['description']?.toString() ?? Localization.translate('no_description'),
                                                style: TextStyle(color: AppColors.of(context).foregroundMuted),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        FadeIn(
                                          duration: const Duration(milliseconds: 300),
                                          child: Tooltip(
                                            message: Localization.translate('import_repo_apps_tooltip'),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Center(
                                                child: Icon(
                                                  Icons.arrow_circle_down_rounded,
                                                  color: Colors.blue[400],
                                                  size: 40,
                                                ),
                                              ),
                                              onPressed: _isLoading ? null : () => _applyRepo(repo['name']),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ),
            ],
          ),
          actions: [
            FadeIn(
              duration: const Duration(milliseconds: 300),
              child: TextButton(
                child: Text(Localization.translate('close'), style: TextStyle(color: AppColors.of(context).foreground, fontSize: 14)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }
}
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/inventory/presentation/controllers/category_controller.dart';
import 'show_error_dialog.dart';
import '../theme/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../features/inventory/presentation/dialogs/settings_language_dialog.dart';

import '../auth/auth_login_controller.dart';

class Navigations extends StatefulWidget {
  final Widget child;

  const Navigations({
    super.key,
    required this.child,
  });

  @override
  State<Navigations> createState() => _NavigationsState();
}

class _NavigationsState extends State<Navigations> {
  static const double _mobileBreakpoint = 600;
  bool _isPaneExpanded = false;

  int getSelectedIndex(String path) {
    switch (path) {
      case '/dashboard':
        return 0;
      case '/stock':
        return 1;
      case '/categories':
        return 2;
      case '/shed':
        return 3;
      case '/new_product':
        return 4;
    }
    return 0;
  }

  Future<bool> _canAccessNewProduct(BuildContext context) async {
    final categoryController = context.read<CategoryController>();

    if (categoryController.categories.isEmpty) {
      await categoryController.loadCategory();
    }

    return categoryController.categories.isNotEmpty;
  }

  Future<void> changePage(BuildContext context, int index) async {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/stock');
        break;
      case 2:
        context.go('/categories');
        break;
      case 3:
        context.go('/shed');
        break;
      case 4:
        if (!await _canAccessNewProduct(context)) {
          if (!context.mounted) return;
          final l10n = AppLocalizations.of(context)!;
          await showErrorDialog(context, l10n.missingProductDependencies);
          return;
        }
        if (!context.mounted) return;
        context.go('/new_product');
        break;
    }
  }

  void _togglePane() {
    setState(() {
      _isPaneExpanded = !_isPaneExpanded;
    });
  }

  Widget _buildSeparator() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: Colors.blue.withOpacity(0.35),
    );
  }

  Widget _buildPaneItem({
    required Widget icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = FluentTheme.of(context);
    final selectedColor = theme.accentColor.defaultBrushFor(theme.brightness);
    final textColor = selected
        ? selectedColor
        : theme.typography.body?.color ?? theme.resources.textFillColorPrimary;
    final backgroundColor = selected
        ? selectedColor.withOpacity(0.12)
        : Colors.transparent;

    final item = material.Material(
      color: Colors.transparent,
      child: material.InkWell(
        borderRadius: material.BorderRadius.circular(8),
        onTap: onTap,
        child: AnimatedContainer(
          duration: theme.fastAnimationDuration,
          curve: theme.animationCurve,
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.symmetric(
            horizontal: _isPaneExpanded ? 12 : 0,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: _isPaneExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              IconTheme.merge(
                data: IconThemeData(color: textColor, size: 18),
                child: icon,
              ),
              if (_isPaneExpanded) ...[
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: theme.typography.body?.copyWith(
                      color: textColor,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return _isPaneExpanded ? item : Tooltip(message: label, child: item);
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState
        .of(context)
        .uri
        .path;
    final selectedIndex = getSelectedIndex(path);
    final theme = FluentTheme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isMobile =
        material.MediaQuery.sizeOf(context).width < _mobileBreakpoint;
    final isDarkTheme = theme.brightness == material.Brightness.dark;
    final compactPaneWidth = isMobile ? 48.0 : 64.0;
    final expandedPaneWidth = isMobile ? 180.0 : 300.0;
    final paneWidth = _isPaneExpanded ? expandedPaneWidth : compactPaneWidth;

    return Stack(
      children: [
        Row(
          children: [
            SizedBox(width: compactPaneWidth),
            Expanded(child: widget.child),
          ],
        ),
        Positioned.fill(
          left: compactPaneWidth,
          child: IgnorePointer(
            ignoring: !_isPaneExpanded,
            child: AnimatedOpacity(
              duration: theme.fastAnimationDuration,
              curve: theme.animationCurve,
              opacity: _isPaneExpanded ? 1 : 0,
              child: material.GestureDetector(
                onTap: _togglePane,
                child: ColoredBox(
                  color: Colors.black.withOpacity(isDarkTheme ? 0.28 : 0.18),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          width: paneWidth,
          child: AnimatedContainer(
            duration: theme.fastAnimationDuration,
            curve: theme.animationCurve,
            width: paneWidth,
            height: double.infinity,
            decoration: material.BoxDecoration(
              gradient: material.LinearGradient(
                begin: material.Alignment.topCenter,
                end: material.Alignment.bottomCenter,
                colors: isDarkTheme
                    ? const [
                        AppTheme.darkPane,
                        material.Color(0xFF13223A),
                        AppTheme.darkBackground,
                      ]
                    : const [
                        AppTheme.lightPane,
                        material.Color(0xFFF6FAFF),
                        material.Color(0xFFEAF7F4),
                      ],
              ),
            ),
          child: material.Material(
            color: Colors.transparent,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: Align(
                      alignment: _isPaneExpanded
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: IconButton(
                        icon: const Icon(FluentIcons.global_nav_button),
                        onPressed: _togglePane,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildSeparator(),
                        _buildPaneItem(
                          icon: const Icon(material.Icons.bar_chart, size: 18),
                          label: l10n.dashboard,
                          selected: selectedIndex == 0,
                          onTap: () => changePage(context, 0),
                        ),
                        _buildSeparator(),
                        _buildPaneItem(
                          icon: const Icon(
                            material.Icons.inventory_2_outlined,
                            size: 18,
                          ),
                          label: l10n.stock,
                          selected: selectedIndex == 1,
                          onTap: () => changePage(context, 1),
                        ),
                        _buildSeparator(),
                        _buildPaneItem(
                          icon: const Icon(
                            material.Icons.category_outlined,
                            size: 18,
                          ),
                          label: l10n.categories,
                          selected: selectedIndex == 2,
                          onTap: () => changePage(context, 2),
                        ),
                        _buildSeparator(),
                        _buildPaneItem(
                          icon: const Icon(
                            material.Icons.warehouse_outlined,
                            size: 18,
                          ),
                          label: l10n.sheds,
                          selected: selectedIndex == 3,
                          onTap: () => changePage(context, 3),
                        ),
                        _buildSeparator(),
                        _buildPaneItem(
                          icon: const Icon(FluentIcons.product_list, size: 18),
                          label: l10n.product,
                          selected: selectedIndex == 4,
                          onTap: () => changePage(context, 4),
                        ),
                        _buildSeparator(),
                      ],
                    ),
                  ),
                  _buildSeparator(),
                  _buildPaneItem(
                    icon: const Icon(FluentIcons.settings, size: 18),
                    label: l10n.settings,
                    selected: false,
                    onTap: () {
                      context.read<SettingsLanguageDialog>()(context: context);
                    },
                  ),
                  _buildSeparator(),
                  _buildPaneItem(
                    icon: const Icon(FluentIcons.sign_out, size: 18),
                    label: l10n.logout,
                    selected: false,
                    onTap: () {
                      context.read<AuthLoginController>().logout();
                      context.go('/login');
                    },
                  ),
                  _buildSeparator(),
                ],
              ),
            ),
          ),
        ),
        ),
      ],
    );
  }
}

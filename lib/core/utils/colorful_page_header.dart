import 'package:estokar_gestaodeestoque/core/theme/app_theme.dart';
import 'package:estokar_gestaodeestoque/app/app_breakpoints.dart';
import 'package:estokar_gestaodeestoque/core/utils/responsive_text_overflow.dart';
import 'package:flutter/material.dart';

class ColorfulPageHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDarkTheme;
  final Widget? actions;
  final List<Widget>? mobileActions;
  final bool mobileActionsBelowHeader;
  final double mobileHeaderWidthFraction;

  const ColorfulPageHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.isDarkTheme,
    this.actions,
    this.mobileActions,
    this.mobileActionsBelowHeader = false,
    this.mobileHeaderWidthFraction = 0.56,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final gradientColors = isDarkTheme
        ? AppTheme.darkGradient
        : AppTheme.lightGradient;

    Widget buildHeaderCard(double width) {
      return Container(
        width: width,
        height: isMobile ? 54 : 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(isMobile ? 16 : 22),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(isDarkTheme ? 0.2 : 0.2),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isMobile ? 36 : 48,
                height: isMobile ? 36 : 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isMobile ? 20 : 26,
                ),
              ),
              SizedBox(width: isMobile ? 10 : 16),
              Flexible(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: responsiveTextOverflow(context),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 22 : 29,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = isMobile ? 8.0 : 12.0;
        final availableWidth = constraints.maxWidth - padding * 2;
        final headerWidth = isMobile
            ? mobileActions == null || mobileActionsBelowHeader
                ? availableWidth
                : (availableWidth - 8) * mobileHeaderWidthFraction
            : availableWidth < 940
                ? 320.0
                : 450.0;
        final headerCard = buildHeaderCard(headerWidth);

        final desktopActions =
            actions ??
            (mobileActions == null
                ? null
                : Row(
                    children: [
                      for (var i = 0; i < mobileActions!.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Expanded(child: mobileActions![i]),
                      ],
                    ],
                  ));

        if (desktopActions == null) {
          return Padding(
            padding: EdgeInsets.all(padding),
            child: headerCard,
          );
        }

        if (isMobile) {
          final filterActions = mobileActions;
          if (filterActions != null && filterActions.isNotEmpty) {
            Widget filterCard(Widget child) {
              return Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: child,
                ),
              );
            }

            Widget actionRow(List<Widget> children) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(child: filterCard(children[i])),
                  ],
                ],
              );
            }

            if (mobileActionsBelowHeader) {
              return Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerCard,
                    const SizedBox(height: 8),
                    actionRow(filterActions.take(2).toList()),
                  ],
                ),
              );
            }

            final lowerActions = filterActions.length == 2
                ? filterActions
                : filterActions.skip(1).toList();

            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (filterActions.length == 1)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerCard,
                        const SizedBox(width: 8),
                        Expanded(child: filterCard(filterActions.first)),
                      ],
                    )
                  else if (filterActions.length == 2)
                    headerCard
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerCard,
                        const SizedBox(width: 8),
                        Expanded(child: filterCard(filterActions.first)),
                      ],
                    ),
                  if (lowerActions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    actionRow(lowerActions.take(2).toList()),
                  ],
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerCard,
                const SizedBox(height: 8),
                desktopActions,
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerCard,
              const SizedBox(width: 12),
              Expanded(child: desktopActions),
            ],
          ),
        );
      },
    );
  }
}


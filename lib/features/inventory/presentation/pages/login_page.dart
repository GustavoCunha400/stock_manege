import 'package:fluent_ui/fluent_ui.dart' show FluentIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_breakpoints.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/controllers/theme_controller.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/usecases/login_erros.dart';
import '../controllers/login_form_controller.dart';
import '../dialogs/login_language_dialog.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginFormController(
        loginErros: context.read<LoginErros>(),
      ),
      child: const _LoginPageBody(),
    );
  }
}

class _LoginPageBody extends StatelessWidget {
  const _LoginPageBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeController = context.watch<ThemeController>();
    final isDarkTheme = themeController.themeMode == ThemeMode.dark;
    final style = _LoginVisualStyle.fromTheme(isDarkTheme);
    final isMobile = context.isMobile;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: style.backgroundGradientColors,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.welcome,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFF5EFEF),
                              letterSpacing: 2,
                              fontSize: isMobile ? 34 : 70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: isMobile ? 12 : 100),
                          _LoginFormCard(
                            style: style,
                            isDarkTheme: isDarkTheme,
                            onToggleTheme: () {
                              themeController.setThemeMode(
                                isDarkTheme ? ThemeMode.light : ThemeMode.dark,
                              );
                            },
                            onShowLanguageDialog: () {
                              context.read<LoginLanguageDialog>()(
                                context: context,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoginFormCard extends StatelessWidget {
  const _LoginFormCard({
    required this.style,
    required this.isDarkTheme,
    required this.onToggleTheme,
    required this.onShowLanguageDialog,
  });

  final _LoginVisualStyle style;
  final bool isDarkTheme;
  final VoidCallback onToggleTheme;
  final VoidCallback onShowLanguageDialog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = context.isMobile;
    final formWidth = isMobile ? context.screenWidth * 0.92 : 600.0;

    return Consumer<LoginFormController>(
      builder: (context, controller, _) {
        return Container(
          width: formWidth,
          constraints: BoxConstraints(
            minHeight: isMobile ? 0 : 520,
            maxWidth: isMobile ? 330 : 600,
          ),
          decoration: BoxDecoration(
            color: style.formContainerColor,
            borderRadius: BorderRadius.circular(isMobile ? 20 : 28),
            border: Border.all(
              color: style.fieldBorderColor.withOpacity(0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkTheme ? 0.3 : 0.1),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 40,
              isMobile ? 18 : 40,
              isMobile ? 16 : 40,
              isMobile ? 16 : 0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LoginHeader(style: style),
                SizedBox(height: isMobile ? 6 : 10),
                _LoginFieldLabel(text: l10n.emailPrompt, style: style),
                SizedBox(height: isMobile ? 10 : 20),
                _LoginTextField(
                  controller: controller.emailController,
                  hintText: l10n.emailHint,
                  icon: Icons.email,
                  borderColor: style.fieldBorderColor,
                  onChanged: controller.clearEmailErrors,
                ),
                if (controller.loginError != null) ...[
                  const SizedBox(height: 5),
                  _LoginErrorText(controller.loginError!),
                ],
                SizedBox(height: isMobile ? 6 : 10),
                _LoginFieldLabel(text: l10n.passwordPrompt, style: style),
                SizedBox(height: isMobile ? 8 : 10),
                _LoginTextField(
                  controller: controller.passwordController,
                  hintText: l10n.passwordHint,
                  icon: Icons.lock,
                  borderColor: style.fieldBorderColor,
                  obscureText: !controller.isPasswordVisible,
                  onChanged: controller.clearPasswordErrors,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: isMobile ? 20 : 25,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                if (controller.passwordError != null) ...[
                  const SizedBox(height: 5),
                  _LoginErrorText(controller.passwordError!),
                ],
                if (controller.loginEmpty != null) ...[
                  const SizedBox(height: 5),
                  _LoginErrorText(controller.loginEmpty!),
                ],
                SizedBox(height: isMobile ? 10 : 15),
                ElevatedButton(
                  onPressed: () async {
                    final didLogin = await controller.submit(l10n);
                    if (!context.mounted || !didLogin) return;

                    context.go('/stock');
                  },
                  child: Text(
                    l10n.loginButton,
                    style: TextStyle(fontSize: isMobile ? 14 : 17),
                  ),
                ),
                SizedBox(height: isMobile ? 6 : 10),
                Text(
                  l10n.noAccount,
                  style: TextStyle(color: style.secondaryTextColor),
                ),
                const SizedBox(height: 2),
                TextButton(
                  onPressed: () {
                    context.go('/create_account');
                  },
                  child: Text(
                    l10n.createAccount,
                    style: TextStyle(fontSize: isMobile ? 14 : 17),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isDarkTheme
                            ? FluentIcons.sunny
                            : FluentIcons.clear_night,
                        size: 18,
                      ),
                      onPressed: onToggleTheme,
                    ),
                    IconButton(
                      icon: const Icon(Icons.translate, size: 18),
                      onPressed: onShowLanguageDialog,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader({required this.style});

  final _LoginVisualStyle style;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = context.isMobile;

    return Column(
      children: [
        Text(
          l10n.loginTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: style.primaryTextColor,
            letterSpacing: 2,
            fontSize: isMobile ? 20 : 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.loginSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: style.secondaryTextColor,
            fontSize: isMobile ? 13 : 15,
          ),
        ),
      ],
    );
  }
}

class _LoginFieldLabel extends StatelessWidget {
  const _LoginFieldLabel({
    required this.text,
    required this.style,
  });

  final String text;
  final _LoginVisualStyle style;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: style.primaryTextColor,
        letterSpacing: 2,
        fontSize: isMobile ? 19 : 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.borderColor,
    required this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color borderColor;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      width: isMobile ? double.infinity : 480,
      height: isMobile ? 42 : 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: borderColor,
          width: isMobile ? 1.5 : 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8.0 : 10.0,
          vertical: 0,
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, size: isMobile ? 18 : null),
            suffixIcon: suffixIcon,
          ),
          obscureText: obscureText,
        ),
      ),
    );
  }
}

class _LoginErrorText extends StatelessWidget {
  const _LoginErrorText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFFD13438),
        fontSize: context.isMobile ? 13 : 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _LoginVisualStyle {
  const _LoginVisualStyle({
    required this.formContainerColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.fieldBorderColor,
    required this.backgroundGradientColors,
  });

  final Color formContainerColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color fieldBorderColor;
  final List<Color> backgroundGradientColors;

  factory _LoginVisualStyle.fromTheme(bool isDarkTheme) {
    return _LoginVisualStyle(
      formContainerColor: isDarkTheme
          ? AppTheme.darkSurface
          : AppTheme.lightSurface,
      primaryTextColor: isDarkTheme
          ? const Color(0xFFF3F7FF)
          : const Color(0xFF17345F),
      secondaryTextColor: isDarkTheme
          ? const Color(0xFFC9D7EA)
          : const Color(0xFF526173),
      fieldBorderColor: isDarkTheme
          ? AppTheme.darkSecondary
          : AppTheme.lightPrimary,
      backgroundGradientColors:
          isDarkTheme ? AppTheme.darkGradient : AppTheme.lightGradient,
    );
  }
}

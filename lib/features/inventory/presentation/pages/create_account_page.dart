import 'package:fluent_ui/fluent_ui.dart'
    show displayInfoBar, InfoBar, InfoBarSeverity;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_breakpoints.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/controllers/theme_controller.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/usecases/create_account.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisivel = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createAccount(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final createAccount = context.read<CreateAccount>();

    final result = await createAccount(
      email: emailController.text,
      password: passwordController.text,
    );

    if (!context.mounted) {
      return;
    }

    final String? errorMessage = switch (result) {
      CreateAccountResult.success => null,
      CreateAccountResult.emptyFields => l10n.fillEmailPassword,
      CreateAccountResult.invalidEmail => l10n.invalidCreateAccountEmail,
      CreateAccountResult.weakPassword => l10n.passwordMinLength,
    };

    if (errorMessage != null) {
      _showError(context, l10n.error, errorMessage);
      return;
    }

    context.go('/stock');
  }

  void _showError(BuildContext context, String title, String message) {
    displayInfoBar(
      context,
      builder: (context, close) {
        return InfoBar(
          title: Text(title),
          content: Text(message),
          severity: InfoBarSeverity.error,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkTheme =
        context.watch<ThemeController>().themeMode == ThemeMode.dark;
    final formContainerColor = isDarkTheme
        ? AppTheme.darkSurface
        : AppTheme.lightSurface;
    final primaryTextColor = isDarkTheme
        ? const Color(0xFFF3F7FF)
        : const Color(0xFF17345F);
    final secondaryTextColor = isDarkTheme
        ? const Color(0xFFC9D7EA)
        : const Color(0xFF526173);
    final fieldBorderColor = isDarkTheme
        ? AppTheme.darkSecondary
        : AppTheme.lightPrimary;
    final backgroundGradientColors = isDarkTheme
        ? AppTheme.darkGradient
        : AppTheme.lightGradient;
    final isMobile = context.isMobile;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundGradientColors,
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
                          SizedBox(height: isMobile ? 14 : 100),
                          Container(
                            width: isMobile ? double.infinity : 600,
                            constraints: BoxConstraints(
                              minHeight: isMobile ? 0 : 600,
                              maxWidth: isMobile ? 330 : 600,
                            ),
                            decoration: BoxDecoration(
                              color: formContainerColor,
                              borderRadius: BorderRadius.circular(
                                isMobile ? 20 : 28,
                              ),
                              border: Border.all(
                                color: fieldBorderColor.withOpacity(0.22),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    isDarkTheme ? 0.32 : 0.14,
                                  ),
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
                                  Text(
                                    l10n.createAccountTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      letterSpacing: 2,
                                      fontSize: isMobile ? 20 : 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 6 : 10),
                                  Text(
                                    l10n.createAccountSubtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: isMobile ? 13 : 15,
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 14 : 40),
                                  Text(
                                    l10n.emailCreatePrompt,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      letterSpacing: 2,
                                      fontSize: isMobile ? 19 : 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 10 : 20),
                                  _CreateAccountTextField(
                                    controller: emailController,
                                    hintText: l10n.emailHint,
                                    icon: Icons.email,
                                    borderColor: fieldBorderColor,
                                  ),
                                  SizedBox(height: isMobile ? 14 : 40),
                                  Text(
                                    l10n.passwordPrompt,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      letterSpacing: 2,
                                      fontSize: isMobile ? 19 : 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 10 : 20),
                                  _CreateAccountTextField(
                                    controller: passwordController,
                                    hintText: l10n.passwordHint,
                                    icon: Icons.lock,
                                    borderColor: fieldBorderColor,
                                    obscureText: !isPasswordVisivel,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPasswordVisivel
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: isMobile ? 20 : 25,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisivel =
                                              !isPasswordVisivel;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 16 : 35),
                                  ElevatedButton(
                                    onPressed: () => createAccount(context),
                                    child: Text(
                                      l10n.create,
                                      style: TextStyle(
                                        fontSize: isMobile ? 14 : 17,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 12 : 30),
                                  TextButton(
                                    onPressed: () {
                                      context.go('/login');
                                    },
                                    child: Text(
                                      l10n.alreadyHaveAccount,
                                      style: TextStyle(
                                        fontSize: isMobile ? 14 : 17,
                                      ),
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }
}

class _CreateAccountTextField extends StatelessWidget {
  const _CreateAccountTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.borderColor,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color borderColor;
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

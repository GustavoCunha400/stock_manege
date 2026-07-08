import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/dialogs/settings_language_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showLanguageDialog();
      }
    });
  }

  Future<void> _showLanguageDialog() async {
    await context.read<SettingsLanguageDialog>()(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}


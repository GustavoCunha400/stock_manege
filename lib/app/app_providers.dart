import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:estokar_gestaodeestoque/features/inventory/presentation/controllers/low_stock_settings_controller.dart';

import '../core/auth/auth_login_controller.dart';
import 'app_router.dart';
import 'di/controller_providers.dart';
import 'di/dialog_providers.dart';
import 'di/repository_providers.dart';
import 'di/usecase_providers.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  // ignore: ddc_missing_field_initialization
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...repositoryProviders,
        ChangeNotifierProvider(create: (_) => AuthLoginController()),
        ...usecaseProviders,
        ...dialogProviders,
        ChangeNotifierProvider(
          create: (_) => LowStockSettingsController()..loadLowStockLimit(),
        ),
        ...controllerProviders,
        Provider(
          create: (context) =>
              createAppRouter(context.read<AuthLoginController>()),
          dispose: (_, router) => router.dispose(),
        ),
      ],
      child: child,
    );
  }
}


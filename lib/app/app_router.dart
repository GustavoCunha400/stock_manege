import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/auth_login_controller.dart';
import '../core/utils/navigations.dart';
import '../features/inventory/presentation/pages/categories_page.dart';
import '../features/inventory/presentation/pages/create_account_page.dart';
import '../features/inventory/presentation/pages/dashboard_page.dart';
import '../features/inventory/presentation/pages/login_page.dart';
import '../features/inventory/presentation/pages/new_product_page.dart';
import '../features/inventory/presentation/pages/settings_page.dart';
import '../features/inventory/presentation/pages/shed_page.dart';
import '../features/inventory/presentation/pages/stock_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(AuthLoginController authController) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: authController,
    redirect: (context, state) {
      final isLoggedIn = authController.isLoggedIn;
      final currentPath = state.uri.path;

      final isLogin = currentPath == '/login' || currentPath == '/';
      final isCreatingAccount = currentPath == '/create_account';

      if (!isLoggedIn && !isLogin && !isCreatingAccount) {
        return '/login';
      }

      if (isLoggedIn && isCreatingAccount) {
        return '/stock';
      }
      return null;
    },
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/create_account',
        builder: (BuildContext context, GoRouterState state) {
          return const CreateAccountPage();
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Navigations(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (BuildContext context, GoRouterState state) {
              return const DashboardPage();
            },
          ),
          GoRoute(
            path: '/categories',
            builder: (BuildContext context, GoRouterState state) {
              return const CategoriesPage();
            },
          ),
          GoRoute(
            path: '/new_product',
            builder: (BuildContext context, GoRouterState state) {
              return const NewProductPage();
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsPage();
            },
          ),
          GoRoute(
            path: '/shed',
            builder: (BuildContext context, GoRouterState state) {
              final filter = state.uri.queryParameters['filter'];
              final lowStockLimit = int.tryParse(
                state.uri.queryParameters['lowStockLimit'] ?? '',
              );
              return ShedPage(
                key: ValueKey('shed-$filter-$lowStockLimit'),
                initialFilter: filter,
                initialLowStockLimit: lowStockLimit,
              );
            },
          ),
          GoRoute(
            path: '/stock',
            builder: (BuildContext context, GoRouterState state) {
              final filter = state.uri.queryParameters['filter'];
              return StockPage(
                key: ValueKey('stock-$filter'),
                initialFilter: filter,
              );
            },
          ),
        ],
      ),
    ],
  );
}


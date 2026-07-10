import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/inventory/presentation/dialogs/add_movimentation.dart';
import '../../features/inventory/presentation/dialogs/add_product_dialog.dart';
import '../../features/inventory/presentation/dialogs/category_actions_dialog.dart';
import '../../features/inventory/presentation/dialogs/create_category_dialog.dart';
import '../../features/inventory/presentation/dialogs/create_shed_dialog.dart';
import '../../features/inventory/presentation/dialogs/edit_category_dialog.dart';
import '../../features/inventory/presentation/dialogs/edit_item.dart';
import '../../features/inventory/presentation/dialogs/edit_shed_dialog.dart';
import '../../features/inventory/presentation/dialogs/login_language_dialog.dart';
import '../../features/inventory/presentation/dialogs/settings_language_dialog.dart';
import '../../features/inventory/presentation/dialogs/show_movimentation_dialog.dart';
import '../../features/inventory/presentation/dialogs/shed_actions_dialog.dart';
import '../../features/inventory/presentation/dialogs/stock_item_actions_dialog.dart';

List<SingleChildWidget> dialogProviders = [
  Provider(create: (context) => AddProductDialog()),
  Provider(create: (context) => EditItem()),
  Provider(create: (context) => AddMovimentation()),
  Provider(create: (context) => ShowMovimentationDialog()),
  Provider(create: (context) => StockItemActionsDialog()),
  Provider(create: (context) => EditCategoryDialog()),
  Provider(create: (context) => CategoryActionsDialog()),
  Provider(create: (context) => CreateCategoryDialog()),
  Provider(create: (context) => CreateShedDialog()),
  Provider(create: (context) => EditShedDialog()),
  Provider(create: (context) => ShedActionsDialog()),
  Provider(create: (context) => SettingsLanguageDialog()),
  Provider(create: (context) => LoginLanguageDialog()),
];

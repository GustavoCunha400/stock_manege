import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/inventory/domain/repositories/estokar_category_repository.dart';
import '../../features/inventory/domain/repositories/estokar_product_repository.dart';
import '../../features/inventory/domain/repositories/estokar_shed_repository.dart';
import '../../features/inventory/domain/services/id_generator.dart';
import '../../features/inventory/domain/usecases/add_category.dart';
import '../../features/inventory/domain/usecases/add_product.dart';
import '../../features/inventory/domain/usecases/add_shed.dart';
import '../../features/inventory/domain/usecases/create_account.dart';
import '../../features/inventory/domain/usecases/create_product.dart';
import '../../features/inventory/domain/usecases/edit_category.dart';
import '../../features/inventory/domain/usecases/edit_product.dart';
import '../../features/inventory/domain/usecases/edit_shed.dart';
import '../../features/inventory/domain/usecases/get_category.dart';
import '../../features/inventory/domain/usecases/get_product.dart';
import '../../features/inventory/domain/usecases/get_shed.dart';
import '../../features/inventory/domain/usecases/login_erros.dart';
import '../../features/inventory/domain/usecases/remove_category.dart';
import '../../features/inventory/domain/usecases/remove_product.dart';
import '../../features/inventory/domain/usecases/remove_shed.dart';
import '../../features/inventory/domain/usecases/update_category.dart';
import '../../features/inventory/domain/usecases/update_product.dart';
import '../../features/inventory/domain/usecases/update_shed.dart';
import '../../features/inventory/presentation/dialogs/add_movimentation.dart';
import '../../features/inventory/presentation/dialogs/add_product_dialog.dart';
import '../../features/inventory/domain/usecases/build_dashboard_report.dart';
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

List<SingleChildWidget> usecaseProviders = [
  Provider(create: (context) => CreateAccount(context.read())),
  Provider(create: (context) => LoginErros(context.read())),
  Provider(
    create: (context) => GetProduct(context.read<EstokarProductRepository>()),
  ),
  Provider(
    create: (context) => AddProduct(
      context.read<EstokarProductRepository>(),
      context.read<IdGenerator>(),
    ),
  ),
  Provider(create: (context) => AddProductDialog()),
  Provider(create: (context) => CreateProduct(context.read<AddProduct>())),
  Provider(create: (context) => EditItem()),
  Provider(create: (context) => AddMovimentation()),
  Provider(create: (context) => ShowMovimentationDialog()),
  Provider(create: (context) => StockItemActionsDialog()),
  Provider(
    create: (context) =>
        RemoveProduct(context.read<EstokarProductRepository>()),
  ),
  Provider(
    create: (context) =>
        UpdateProduct(context.read<EstokarProductRepository>()),
  ),
  Provider(
    create: (context) => GetCategory(context.read<EstokarCategoryRepository>()),
  ),
  Provider(
    create: (context) => AddCategory(
      context.read<EstokarCategoryRepository>(),
      context.read<IdGenerator>(),
    ),
  ),
  Provider(
    create: (context) =>
        RemoveCategory(context.read<EstokarCategoryRepository>()),
  ),
  Provider(
    create: (context) =>
        UpdateCategory(context.read<EstokarCategoryRepository>()),
  ),
  Provider(
    create: (context) => EditCategory(
      context.read<EstokarCategoryRepository>(),
      context.read<IdGenerator>(),
    ),
  ),
  Provider(create: (context) => EditCategoryDialog()),
  Provider(create: (context) => CategoryActionsDialog()),
  Provider(create: (context) => CreateCategoryDialog()),
  Provider(create: (context) => GetShed(context.read<EstokarShedRepository>())),
  Provider(
    create: (context) => AddShed(
      context.read<EstokarShedRepository>(),
      context.read<IdGenerator>(),
    ),
  ),
  Provider(create: (context) => CreateShedDialog()),
  Provider(create: (context) => EditShedDialog()),
  Provider(create: (context) => ShedActionsDialog()),
  Provider(
    create: (context) => RemoveShed(context.read<EstokarShedRepository>()),
  ),
  Provider(
    create: (context) => UpdateShed(context.read<EstokarShedRepository>()),
  ),
  Provider(
    create: (context) => EditProduct(context.read<EstokarProductRepository>()),
  ),
  Provider(
    create: (context) => EditShed(context.read<EstokarShedRepository>()),
  ),
  Provider(create: (context) => SettingsLanguageDialog()),
  Provider(create: (context) => LoginLanguageDialog()),
  Provider(create: (context) => BuildDashboardReport()),
];


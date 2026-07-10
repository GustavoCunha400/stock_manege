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
import '../../features/inventory/domain/usecases/register_stock_movement.dart';
import '../../features/inventory/domain/usecases/build_dashboard_report.dart';

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
  Provider(create: (context) => CreateProduct(context.read<AddProduct>())),
  Provider(create: (context) => RegisterStockMovement()),
  Provider(
    create: (context) =>
        RemoveProduct(context.read<EstokarProductRepository>()),
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
    create: (context) => EditCategory(
      context.read<EstokarCategoryRepository>(),
      context.read<IdGenerator>(),
    ),
  ),
  Provider(create: (context) => GetShed(context.read<EstokarShedRepository>())),
  Provider(
    create: (context) => AddShed(
      context.read<EstokarShedRepository>(),
      context.read<IdGenerator>(),
    ),
  ),
  Provider(
    create: (context) => RemoveShed(context.read<EstokarShedRepository>()),
  ),
  Provider(
    create: (context) => EditProduct(context.read<EstokarProductRepository>()),
  ),
  Provider(
    create: (context) => EditShed(context.read<EstokarShedRepository>()),
  ),
  Provider(create: (context) => BuildDashboardReport()),
];

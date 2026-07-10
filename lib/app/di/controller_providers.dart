import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/theme/controllers/theme_controller.dart';
import '../../features/inventory/domain/usecases/add_category.dart';
import '../../features/inventory/domain/usecases/add_product.dart';
import '../../features/inventory/domain/usecases/add_shed.dart';
import '../../features/inventory/domain/usecases/create_product.dart';
import '../../features/inventory/domain/usecases/edit_category.dart';
import '../../features/inventory/domain/usecases/edit_product.dart';
import '../../features/inventory/domain/usecases/edit_shed.dart';
import '../../features/inventory/domain/usecases/get_category.dart';
import '../../features/inventory/domain/usecases/get_product.dart';
import '../../features/inventory/domain/usecases/get_shed.dart';
import '../../features/inventory/domain/usecases/remove_category.dart';
import '../../features/inventory/domain/usecases/remove_product.dart';
import '../../features/inventory/domain/usecases/remove_shed.dart';
import '../../features/inventory/domain/usecases/register_stock_movement.dart';
import '../../features/inventory/presentation/controllers/category_controller.dart';
import '../../features/inventory/presentation/controllers/new_product_form_controller.dart';
import '../../features/inventory/presentation/controllers/product_controller.dart';
import '../../features/inventory/presentation/controllers/settings_language_form_controller.dart';
import '../../features/inventory/presentation/controllers/shed_controller.dart';
import '../../features/inventory/presentation/controllers/stock_movement_form_controller.dart';
import '../../l10n/locale/locale_controller.dart';

List<SingleChildWidget> controllerProviders = [
  ChangeNotifierProvider(create: (_) => ThemeController()),
  ChangeNotifierProvider(create: (_) => LocaleController()),
  ChangeNotifierProvider(create: (_) => NewProductFormController()),
  ChangeNotifierProvider(create: (_) => StockMovementFormController()),
  ChangeNotifierProvider(create: (_) => SettingsLanguageFormController()),
  ChangeNotifierProvider(
    create: (context) => ProductController(
      getProducts: context.read<GetProduct>(),
      addProduct: context.read<AddProduct>(),
      createProductUseCase: context.read<CreateProduct>(),
      removeProduct: context.read<RemoveProduct>(),
      editProductUseCase: context.read<EditProduct>(),
      registerStockMovementUseCase: context.read<RegisterStockMovement>(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => CategoryController(
      getCategory: context.read<GetCategory>(),
      addCategory: context.read<AddCategory>(),
      removeCategory: context.read<RemoveCategory>(),
      editCategoryUseCase: context.read<EditCategory>(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => ShedController(
      getShed: context.read<GetShed>(),
      addShed: context.read<AddShed>(),
      removeShed: context.read<RemoveShed>(),
      editShedUseCase: context.read<EditShed>(),
    ),
  ),
];

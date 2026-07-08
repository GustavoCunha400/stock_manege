import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/inventory/data/repositories/estokar_category_memory_repository.dart';
import '../../features/inventory/data/repositories/estokar_product_memory_repository.dart';
import '../../features/inventory/data/repositories/estokar_shed_memory_repository.dart';
import '../../features/inventory/data/services/uuid_id_generator.dart';
import '../../features/inventory/domain/repositories/estokar_category_repository.dart';
import '../../features/inventory/domain/repositories/estokar_product_repository.dart';
import '../../features/inventory/domain/repositories/estokar_shed_repository.dart';
import '../../features/inventory/domain/services/id_generator.dart';

List<SingleChildWidget> repositoryProviders = [
  Provider<IdGenerator>(create: (_) => UuidIdGenerator()),
  Provider<EstokarProductRepository>(
    create: (_) => EstokarProductMemoryRepository(),
  ),
  Provider<EstokarCategoryRepository>(
    create: (_) => EstokarCategoryMemoryRepository(),
  ),
  Provider<EstokarShedRepository>(create: (_) => EstokarShedMemoryRepository()),
];


// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get languagePortuguese => 'Portugués';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get menu => 'Menú';

  @override
  String get stock => 'Inventario';

  @override
  String get categories => 'Categorías';

  @override
  String get sheds => 'Almacenes';

  @override
  String get newProduct => 'Nuevo Producto';

  @override
  String get settings => 'Configuración';

  @override
  String get logout => 'Salir';

  @override
  String get welcome => '¡Bienvenido a Estokar!';

  @override
  String get loginTitle => 'Ingresa a tu cuenta';

  @override
  String get loginSubtitle => 'Accede a tu cuenta para continuar';

  @override
  String get emailPrompt => 'Ingresa tu correo:';

  @override
  String get emailCreatePrompt => 'Ingresa tu correo:';

  @override
  String get passwordPrompt => 'Ingresa tu contraseña:';

  @override
  String get emailHint => 'Correo';

  @override
  String get passwordHint => 'Contraseña';

  @override
  String get loginButton => 'Entrar';

  @override
  String get noAccount => '¿Aún no tienes una cuenta?';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get createAccountTitle => 'Crea tu cuenta';

  @override
  String get createAccountSubtitle => 'Crea tu cuenta y facilita tu gestión';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get fillEmailPassword => 'Completa correo y contraseña.';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 8 caracteres.';

  @override
  String get invalidEmailPassword => 'Correo o contraseña inválidos.';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get language => 'Idioma';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get darkTheme => 'Tema Oscuro';

  @override
  String get active => 'Activo';

  @override
  String get lightThemeActive => 'Tema claro activo';

  @override
  String get noProduct => 'No hay productos registrados';

  @override
  String get registerProductFirst => 'Registra un producto primero.';

  @override
  String get addMovement => 'Agregar movimiento';

  @override
  String get product => 'Producto';

  @override
  String get observation => 'Observación';

  @override
  String currentStock(String value) {
    return 'Inventario actual: $value';
  }

  @override
  String get entry => 'Entrada';

  @override
  String get exit => 'Salida';

  @override
  String get register => 'Registrar';

  @override
  String get invalidMovementQuantity => 'Ingresa una entrada o salida válida.';

  @override
  String get exitGreaterThanStock =>
      'Inventario insuficiente para registrar esta salida.';

  @override
  String get entryGreaterThanShedCapacity =>
      'La entrada no puede ser mayor que la capacidad disponible del almacén.';

  @override
  String get unableToRegister => 'No fue posible registrar.';

  @override
  String get currentQuantity => 'Cantidad actual';

  @override
  String get entryQuantity => 'Cantidad de entradas';

  @override
  String get exitQuantity => 'Cantidad de salidas';

  @override
  String get entryValue => 'Valor de entrada';

  @override
  String get exitValue => 'Valor de salida';

  @override
  String get finalValue => 'Valor final';

  @override
  String get deleteOrEditItem => 'Eliminar o Editar Ítem';

  @override
  String get deleteItemQuestion => '¿Deseas eliminar este ítem?';

  @override
  String get remove => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get no => 'No';

  @override
  String get categoriesAndSubcategories => 'Categorías y Subcategorías';

  @override
  String get noCategory => 'No hay categorías registradas';

  @override
  String get searchProductByCategory => 'Buscar producto en la categoría';

  @override
  String get noCategoryFoundForProduct =>
      'No se encontró ninguna categoría para este producto.';

  @override
  String get deleteOrEditCategory => 'Eliminar o editar categoría';

  @override
  String get deleteCategoryQuestion => '¿Deseas eliminar esta categoría?';

  @override
  String get addSubcategory => 'Agregar subcategoría';

  @override
  String get addCategory => 'Agregar categoría';

  @override
  String get name => 'Nombre';

  @override
  String get sku => 'SKU';

  @override
  String get description => 'Descripción';

  @override
  String get subcategoriesSeparated => 'Subcategorías separadas por coma';

  @override
  String get add => 'Agregar';

  @override
  String get shedsTitle => 'Almacenes';

  @override
  String get noShed => 'No hay almacenes registrados';

  @override
  String get invalidCapacity => 'Ingresa una capacidad válida.';

  @override
  String get capacity => 'Capacidad';

  @override
  String capacityValue(String value) {
    return 'Capacidad: $value';
  }

  @override
  String usedCapacityValue(String value) {
    return 'Usado: $value';
  }

  @override
  String get deleteOrEditShed => 'Eliminar o editar almacén';

  @override
  String get addShed => 'Agregar almacén';

  @override
  String get location => 'Ubicación';

  @override
  String get createNewProduct => 'Crear nuevo producto';

  @override
  String get imageUrl => 'URL de la Imagen';

  @override
  String get price => 'Precio';

  @override
  String get category => 'Categoría';

  @override
  String get subcategory => 'Subcategoría';

  @override
  String get shed => 'Almacén';

  @override
  String get create => 'Crear';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get registeredProducts => 'Productos registrados';

  @override
  String get stockItems => 'Ítems en inventario';

  @override
  String get totalStockValue => 'Valor total del inventario';

  @override
  String get lowStock => 'Bajo inventario';

  @override
  String get lowStockLimit => 'Límite de bajo inventario';

  @override
  String upToUnits(String value) {
    return 'Hasta $value unidades';
  }

  @override
  String get totalEntries => 'Cantidad de entradas';

  @override
  String get totalExits => 'Cantidad de salidas';

  @override
  String get recentMovements => 'Movimientos recientes';

  @override
  String get recentMovementsSubtitle =>
      'Entradas y salidas registradas en los últimos 7 días';

  @override
  String get noRecentMovements => 'No hay movimientos registrados.';

  @override
  String get topExitProducts => 'Productos con más salidas';

  @override
  String get topExitProductsSubtitle => 'Cantidad total retirada por producto';

  @override
  String get noProductExits => 'No hay productos con salidas registradas.';

  @override
  String get topExitCategories => 'Categorías con más salidas';

  @override
  String get topExitCategoriesSubtitle =>
      'Cantidad total retirada por categoría';

  @override
  String get noCategoryExits => 'No hay categorÃ­as con salidas registradas.';

  @override
  String get stockByCategory => 'Inventario por categoría';

  @override
  String get stockByCategorySubtitle => 'Total de productos por categoría';

  @override
  String get noCategoryStock =>
      'No hay productos con inventario en esta categoría.';

  @override
  String get stockValueByCategory => 'Valor inmovilizado por categoría';

  @override
  String get stockValueByCategorySubtitle =>
      'Inventario actual multiplicado por el precio del producto';

  @override
  String get noStockValue => 'Registra productos con precio e inventario.';

  @override
  String get uncategorized => 'Sin categoría';

  @override
  String get allCategories => 'Todas las categorías';

  @override
  String get noProductInCategory =>
      'No se encontraron productos en esta categoría.';

  @override
  String get missingProductDependencies =>
      'Registra al menos una categoría antes de crear productos.';

  @override
  String get invalidProductFields =>
      'Ingresa SKU, precio, inventario, categoría y subcategoría válidos.';

  @override
  String get emailNotRegistered => 'Correo no registrado.';

  @override
  String get loginEmptyFields =>
      'Ingresa el correo y la contraseña para entrar.';

  @override
  String get incorrectPassword => 'Contraseña incorrecta o no registrada.';

  @override
  String get invalidCreateAccountEmail =>
      'Ingresa un correo válido con @ y terminación .com.';

  @override
  String get searchByCity => 'Buscar por ciudad';

  @override
  String get availability => 'Disponibilidad';

  @override
  String get allSheds => 'Todos los almacenes';

  @override
  String get withAvailableStock => 'Con inventario disponible';

  @override
  String get withoutAvailableStock => 'Sin inventario disponible';

  @override
  String get withLowStockProducts => 'Con productos de bajo inventario';

  @override
  String get noShedForFilters =>
      'No se encontraron almacenes para estos filtros.';

  @override
  String get productsInShed => 'Productos en este almacén';

  @override
  String get noProductsInShed =>
      'No hay productos registrados en este almacén.';

  @override
  String get searchingCep => 'Buscando código postal...';

  @override
  String get cepNotFound => 'Código postal no encontrado.';

  @override
  String get unableToSearchCep => 'No fue posible buscar el código postal.';

  @override
  String get invalidCep => 'Ingresa un código postal válido.';

  @override
  String get searchValidCepBeforeSavingShed =>
      'Busca un código postal válido antes de guardar el almacén.';

  @override
  String get searchValidCepBeforeCreatingShed =>
      'Busca un código postal válido antes de registrar el almacén.';

  @override
  String get shedCapacityExceeded =>
      'La entrada supera la capacidad del almacén.';

  @override
  String get productNameRequired => 'Ingresa el nombre del producto.';

  @override
  String get productSkuRequired => 'Ingresa el SKU del producto.';

  @override
  String get productDescriptionRequired =>
      'Ingresa la descripción del producto.';

  @override
  String get invalidImageUrl =>
      'Ingresa una URL de imagen válida o deja el campo vacío.';

  @override
  String get invalidPrice => 'Ingresa un precio válido.';

  @override
  String get priceGreaterThanZero => 'El precio debe ser mayor que cero.';

  @override
  String get selectCategory => 'Selecciona una categoría.';

  @override
  String get selectSubcategory => 'Selecciona una subcategoría.';
}

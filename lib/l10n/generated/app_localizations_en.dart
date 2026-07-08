// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languagePortuguese => 'Portuguese';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get menu => 'Menu';

  @override
  String get stock => 'Stock';

  @override
  String get categories => 'Categories';

  @override
  String get sheds => 'Warehouses';

  @override
  String get newProduct => 'New Product';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get welcome => 'Welcome to Estokar!';

  @override
  String get loginTitle => 'Sign in to your account';

  @override
  String get loginSubtitle => 'Access your account to continue';

  @override
  String get emailPrompt => 'Enter your email:';

  @override
  String get emailCreatePrompt => 'Enter your email:';

  @override
  String get passwordPrompt => 'Enter your password:';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get noAccount => 'Don\'t have an account yet?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountTitle => 'Create your account';

  @override
  String get createAccountSubtitle =>
      'Create your account and simplify your management';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get fillEmailPassword => 'Fill in email and password.';

  @override
  String get passwordMinLength =>
      'The password must be at least 8 characters long.';

  @override
  String get invalidEmailPassword => 'Invalid email or password.';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get language => 'Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get active => 'Active';

  @override
  String get lightThemeActive => 'Light theme active';

  @override
  String get noProduct => 'No products registered';

  @override
  String get registerProductFirst => 'Register a product first.';

  @override
  String get addMovement => 'Add movement';

  @override
  String get product => 'Product';

  @override
  String get observation => 'Observation';

  @override
  String currentStock(String value) {
    return 'Current stock: $value';
  }

  @override
  String get entry => 'Entry';

  @override
  String get exit => 'Exit';

  @override
  String get register => 'Register';

  @override
  String get invalidMovementQuantity => 'Enter a valid entry or exit quantity.';

  @override
  String get exitGreaterThanStock =>
      'Insufficient stock to register this exit.';

  @override
  String get entryGreaterThanShedCapacity =>
      'The entry quantity cannot be greater than the available warehouse capacity.';

  @override
  String get unableToRegister => 'Could not register.';

  @override
  String get currentQuantity => 'Current quantity';

  @override
  String get entryQuantity => 'Entry quantity';

  @override
  String get exitQuantity => 'Exit quantity';

  @override
  String get entryValue => 'Entry value';

  @override
  String get exitValue => 'Exit value';

  @override
  String get finalValue => 'Final value';

  @override
  String get deleteOrEditItem => 'Delete or Edit Item';

  @override
  String get deleteItemQuestion => 'Do you want to delete this item?';

  @override
  String get remove => 'Remove';

  @override
  String get edit => 'Edit';

  @override
  String get no => 'No';

  @override
  String get categoriesAndSubcategories => 'Categories and Subcategories';

  @override
  String get noCategory => 'No categories registered';

  @override
  String get searchProductByCategory => 'Search for a product in the category';

  @override
  String get noCategoryFoundForProduct => 'No category found for this product.';

  @override
  String get deleteOrEditCategory => 'Delete or edit category';

  @override
  String get deleteCategoryQuestion => 'Do you want to delete this category?';

  @override
  String get addSubcategory => 'Add subcategory';

  @override
  String get addCategory => 'Add category';

  @override
  String get name => 'Name';

  @override
  String get sku => 'SKU';

  @override
  String get description => 'Description';

  @override
  String get subcategoriesSeparated => 'Subcategories separated by comma';

  @override
  String get add => 'Add';

  @override
  String get shedsTitle => 'Warehouses';

  @override
  String get noShed => 'No warehouses registered';

  @override
  String get invalidCapacity => 'Enter a valid capacity.';

  @override
  String get capacity => 'Capacity';

  @override
  String capacityValue(String value) {
    return 'Capacity: $value';
  }

  @override
  String usedCapacityValue(String value) {
    return 'Used: $value';
  }

  @override
  String get deleteOrEditShed => 'Delete or edit warehouse';

  @override
  String get addShed => 'Add warehouse';

  @override
  String get location => 'Location';

  @override
  String get createNewProduct => 'Create new product';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get price => 'Price';

  @override
  String get category => 'Category';

  @override
  String get subcategory => 'Subcategory';

  @override
  String get shed => 'Warehouse';

  @override
  String get create => 'Create';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get registeredProducts => 'Registered products';

  @override
  String get stockItems => 'Items in stock';

  @override
  String get totalStockValue => 'Total stock value';

  @override
  String get lowStock => 'Low stock';

  @override
  String get lowStockLimit => 'Low stock limit';

  @override
  String upToUnits(String value) {
    return 'Up to $value units';
  }

  @override
  String get totalEntries => 'Entry quantity';

  @override
  String get totalExits => 'Exit quantity';

  @override
  String get recentMovements => 'Recent movements';

  @override
  String get recentMovementsSubtitle =>
      'Entries and exits registered in the last 7 days';

  @override
  String get noRecentMovements => 'No movements registered.';

  @override
  String get topExitProducts => 'Products with most exits';

  @override
  String get topExitProductsSubtitle => 'Total quantity removed by product';

  @override
  String get noProductExits => 'No products with registered exits.';

  @override
  String get topExitCategories => 'Categories with most exits';

  @override
  String get topExitCategoriesSubtitle => 'Total quantity removed by category';

  @override
  String get noCategoryExits => 'No categories with registered exits.';

  @override
  String get stockByCategory => 'Stock by category';

  @override
  String get stockByCategorySubtitle => 'Total products by category';

  @override
  String get noCategoryStock => 'No products with stock in this category.';

  @override
  String get stockValueByCategory => 'Idle stock value by category';

  @override
  String get stockValueByCategorySubtitle =>
      'Current stock multiplied by product price';

  @override
  String get noStockValue => 'Register products with price and stock.';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get allCategories => 'All categories';

  @override
  String get noProductInCategory => 'No products found in this category.';

  @override
  String get missingProductDependencies =>
      'Register at least one category before creating products.';

  @override
  String get invalidProductFields =>
      'Enter valid SKU, price, stock, category and subcategory.';

  @override
  String get emailNotRegistered => 'Email is not registered.';

  @override
  String get loginEmptyFields => 'Enter email and password to sign in.';

  @override
  String get incorrectPassword => 'Incorrect or unregistered password.';

  @override
  String get invalidCreateAccountEmail =>
      'Enter a valid email with @ and ending in .com.';

  @override
  String get searchByCity => 'Search by city';

  @override
  String get availability => 'Availability';

  @override
  String get allSheds => 'All warehouses';

  @override
  String get withAvailableStock => 'With available stock';

  @override
  String get withoutAvailableStock => 'Without available stock';

  @override
  String get withLowStockProducts => 'With low-stock products';

  @override
  String get noShedForFilters => 'No warehouses found for these filters.';

  @override
  String get productsInShed => 'Products in this warehouse';

  @override
  String get noProductsInShed => 'No products registered in this warehouse.';

  @override
  String get searchingCep => 'Searching ZIP code...';

  @override
  String get cepNotFound => 'ZIP code not found.';

  @override
  String get unableToSearchCep => 'Could not search ZIP code.';

  @override
  String get invalidCep => 'Enter a valid ZIP code.';

  @override
  String get searchValidCepBeforeSavingShed =>
      'Search a valid ZIP code before saving the warehouse.';

  @override
  String get searchValidCepBeforeCreatingShed =>
      'Search a valid ZIP code before creating the warehouse.';

  @override
  String get shedCapacityExceeded =>
      'The entry exceeds the warehouse capacity.';

  @override
  String get productNameRequired => 'Enter the product name.';

  @override
  String get productSkuRequired => 'Enter the product SKU.';

  @override
  String get productDescriptionRequired => 'Enter the product description.';

  @override
  String get invalidImageUrl =>
      'Enter a valid image URL or leave the field empty.';

  @override
  String get invalidPrice => 'Enter a valid price.';

  @override
  String get priceGreaterThanZero => 'The price must be greater than zero.';

  @override
  String get selectCategory => 'Select a category.';

  @override
  String get selectSubcategory => 'Select a subcategory.';
}

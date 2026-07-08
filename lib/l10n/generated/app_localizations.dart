import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @languagePortuguese.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageEnglish.
  ///
  /// In pt, this message translates to:
  /// **'Inglês'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In pt, this message translates to:
  /// **'Espanhol'**
  String get languageSpanish;

  /// No description provided for @menu.
  ///
  /// In pt, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @stock.
  ///
  /// In pt, this message translates to:
  /// **'Estoque'**
  String get stock;

  /// No description provided for @categories.
  ///
  /// In pt, this message translates to:
  /// **'Categorias'**
  String get categories;

  /// No description provided for @sheds.
  ///
  /// In pt, this message translates to:
  /// **'Galpões'**
  String get sheds;

  /// No description provided for @newProduct.
  ///
  /// In pt, this message translates to:
  /// **'Novo Produto'**
  String get newProduct;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get logout;

  /// No description provided for @welcome.
  ///
  /// In pt, this message translates to:
  /// **'Bem Vindo ao Estokar!'**
  String get welcome;

  /// No description provided for @loginTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entre com sua conta'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Acesse sua conta para continuar'**
  String get loginSubtitle;

  /// No description provided for @emailPrompt.
  ///
  /// In pt, this message translates to:
  /// **'Entre com seu e-mail:'**
  String get emailPrompt;

  /// No description provided for @emailCreatePrompt.
  ///
  /// In pt, this message translates to:
  /// **'Digite seu E-mail:'**
  String get emailCreatePrompt;

  /// No description provided for @passwordPrompt.
  ///
  /// In pt, this message translates to:
  /// **'Digite sua Senha:'**
  String get passwordPrompt;

  /// No description provided for @emailHint.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não possui uma conta?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In pt, this message translates to:
  /// **'Criar Conta'**
  String get createAccount;

  /// No description provided for @createAccountTitle.
  ///
  /// In pt, this message translates to:
  /// **'Crie sua conta'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Crie sua conta e facilite sua gestão conosco'**
  String get createAccountSubtitle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Já possui uma conta?'**
  String get alreadyHaveAccount;

  /// No description provided for @error.
  ///
  /// In pt, this message translates to:
  /// **'Erro'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @fillEmailPassword.
  ///
  /// In pt, this message translates to:
  /// **'Preencha email e senha.'**
  String get fillEmailPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter pelo menos 8 caracteres.'**
  String get passwordMinLength;

  /// No description provided for @invalidEmailPassword.
  ///
  /// In pt, this message translates to:
  /// **'Email ou senha inválidos.'**
  String get invalidEmailPassword;

  /// No description provided for @selectLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar idioma'**
  String get selectLanguage;

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @darkTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema Escuro'**
  String get darkTheme;

  /// No description provided for @active.
  ///
  /// In pt, this message translates to:
  /// **'Ativo'**
  String get active;

  /// No description provided for @lightThemeActive.
  ///
  /// In pt, this message translates to:
  /// **'Tema Claro ativo'**
  String get lightThemeActive;

  /// No description provided for @noProduct.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto cadastrado'**
  String get noProduct;

  /// No description provided for @registerProductFirst.
  ///
  /// In pt, this message translates to:
  /// **'Cadastre um produto antes.'**
  String get registerProductFirst;

  /// No description provided for @addMovement.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar movimentação'**
  String get addMovement;

  /// No description provided for @product.
  ///
  /// In pt, this message translates to:
  /// **'Produto'**
  String get product;

  /// No description provided for @observation.
  ///
  /// In pt, this message translates to:
  /// **'Observação'**
  String get observation;

  /// No description provided for @currentStock.
  ///
  /// In pt, this message translates to:
  /// **'Estoque atual: {value}'**
  String currentStock(String value);

  /// No description provided for @entry.
  ///
  /// In pt, this message translates to:
  /// **'Entrada'**
  String get entry;

  /// No description provided for @exit.
  ///
  /// In pt, this message translates to:
  /// **'Saída'**
  String get exit;

  /// No description provided for @register.
  ///
  /// In pt, this message translates to:
  /// **'Registrar'**
  String get register;

  /// No description provided for @invalidMovementQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Informe uma entrada ou saída válida.'**
  String get invalidMovementQuantity;

  /// No description provided for @exitGreaterThanStock.
  ///
  /// In pt, this message translates to:
  /// **'Estoque insuficiente para realizar esta saída.'**
  String get exitGreaterThanStock;

  /// No description provided for @entryGreaterThanShedCapacity.
  ///
  /// In pt, this message translates to:
  /// **'A entrada não pode ser maior que a capacidade disponível do galpão.'**
  String get entryGreaterThanShedCapacity;

  /// No description provided for @unableToRegister.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível registrar.'**
  String get unableToRegister;

  /// No description provided for @currentQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade atual'**
  String get currentQuantity;

  /// No description provided for @entryQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade de entradas'**
  String get entryQuantity;

  /// No description provided for @exitQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade de saídas'**
  String get exitQuantity;

  /// No description provided for @entryValue.
  ///
  /// In pt, this message translates to:
  /// **'Valor de entrada'**
  String get entryValue;

  /// No description provided for @exitValue.
  ///
  /// In pt, this message translates to:
  /// **'Valor de saída'**
  String get exitValue;

  /// No description provided for @finalValue.
  ///
  /// In pt, this message translates to:
  /// **'Valor final'**
  String get finalValue;

  /// No description provided for @deleteOrEditItem.
  ///
  /// In pt, this message translates to:
  /// **'Excluir ou Editar Item'**
  String get deleteOrEditItem;

  /// No description provided for @deleteItemQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir este item?'**
  String get deleteItemQuestion;

  /// No description provided for @remove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get remove;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @no.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get no;

  /// No description provided for @categoriesAndSubcategories.
  ///
  /// In pt, this message translates to:
  /// **'Categorias e Subcategorias'**
  String get categoriesAndSubcategories;

  /// No description provided for @noCategory.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria cadastrada'**
  String get noCategory;

  /// No description provided for @searchProductByCategory.
  ///
  /// In pt, this message translates to:
  /// **'Procurar por produto da categoria'**
  String get searchProductByCategory;

  /// No description provided for @noCategoryFoundForProduct.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria encontrada para este produto.'**
  String get noCategoryFoundForProduct;

  /// No description provided for @deleteOrEditCategory.
  ///
  /// In pt, this message translates to:
  /// **'Excluir ou editar categoria'**
  String get deleteOrEditCategory;

  /// No description provided for @deleteCategoryQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Deseja excluir esta categoria?'**
  String get deleteCategoryQuestion;

  /// No description provided for @addSubcategory.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar subcategoria'**
  String get addSubcategory;

  /// No description provided for @addCategory.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar categoria'**
  String get addCategory;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @sku.
  ///
  /// In pt, this message translates to:
  /// **'SKU'**
  String get sku;

  /// No description provided for @description.
  ///
  /// In pt, this message translates to:
  /// **'Descrição'**
  String get description;

  /// No description provided for @subcategoriesSeparated.
  ///
  /// In pt, this message translates to:
  /// **'Subcategorias separadas por vírgula'**
  String get subcategoriesSeparated;

  /// No description provided for @add.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get add;

  /// No description provided for @shedsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Galpões'**
  String get shedsTitle;

  /// No description provided for @noShed.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum galpão cadastrado'**
  String get noShed;

  /// No description provided for @invalidCapacity.
  ///
  /// In pt, this message translates to:
  /// **'Informe uma capacidade válida.'**
  String get invalidCapacity;

  /// No description provided for @capacity.
  ///
  /// In pt, this message translates to:
  /// **'Capacidade'**
  String get capacity;

  /// No description provided for @capacityValue.
  ///
  /// In pt, this message translates to:
  /// **'Capacidade: {value}'**
  String capacityValue(String value);

  /// No description provided for @usedCapacityValue.
  ///
  /// In pt, this message translates to:
  /// **'Usado: {value}'**
  String usedCapacityValue(String value);

  /// No description provided for @deleteOrEditShed.
  ///
  /// In pt, this message translates to:
  /// **'Excluir ou editar galpão'**
  String get deleteOrEditShed;

  /// No description provided for @addShed.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar galpão'**
  String get addShed;

  /// No description provided for @location.
  ///
  /// In pt, this message translates to:
  /// **'Localização'**
  String get location;

  /// No description provided for @createNewProduct.
  ///
  /// In pt, this message translates to:
  /// **'Criar novo produto'**
  String get createNewProduct;

  /// No description provided for @imageUrl.
  ///
  /// In pt, this message translates to:
  /// **'URL da Imagem'**
  String get imageUrl;

  /// No description provided for @price.
  ///
  /// In pt, this message translates to:
  /// **'Preço'**
  String get price;

  /// No description provided for @category.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get category;

  /// No description provided for @subcategory.
  ///
  /// In pt, this message translates to:
  /// **'Subcategoria'**
  String get subcategory;

  /// No description provided for @shed.
  ///
  /// In pt, this message translates to:
  /// **'Galpão'**
  String get shed;

  /// No description provided for @create.
  ///
  /// In pt, this message translates to:
  /// **'Criar'**
  String get create;

  /// No description provided for @dashboard.
  ///
  /// In pt, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @registeredProducts.
  ///
  /// In pt, this message translates to:
  /// **'Produtos cadastrados'**
  String get registeredProducts;

  /// No description provided for @stockItems.
  ///
  /// In pt, this message translates to:
  /// **'Itens em estoque'**
  String get stockItems;

  /// No description provided for @totalStockValue.
  ///
  /// In pt, this message translates to:
  /// **'Valor total em estoque'**
  String get totalStockValue;

  /// No description provided for @lowStock.
  ///
  /// In pt, this message translates to:
  /// **'Baixo estoque'**
  String get lowStock;

  /// No description provided for @lowStockLimit.
  ///
  /// In pt, this message translates to:
  /// **'Limite para baixo estoque'**
  String get lowStockLimit;

  /// No description provided for @upToUnits.
  ///
  /// In pt, this message translates to:
  /// **'Até {value} unidades'**
  String upToUnits(String value);

  /// No description provided for @totalEntries.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade de entradas'**
  String get totalEntries;

  /// No description provided for @totalExits.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade de saídas'**
  String get totalExits;

  /// No description provided for @recentMovements.
  ///
  /// In pt, this message translates to:
  /// **'Movimentações recentes'**
  String get recentMovements;

  /// No description provided for @recentMovementsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Entradas e saídas registradas nos últimos 7 dias'**
  String get recentMovementsSubtitle;

  /// No description provided for @noRecentMovements.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma movimentação registrada.'**
  String get noRecentMovements;

  /// No description provided for @topExitProducts.
  ///
  /// In pt, this message translates to:
  /// **'Produtos com mais saídas'**
  String get topExitProducts;

  /// No description provided for @topExitProductsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade total retirada por produto'**
  String get topExitProductsSubtitle;

  /// No description provided for @noProductExits.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto com saídas registradas.'**
  String get noProductExits;

  /// No description provided for @topExitCategories.
  ///
  /// In pt, this message translates to:
  /// **'Categorias com mais saídas'**
  String get topExitCategories;

  /// No description provided for @topExitCategoriesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade total retirada por categoria'**
  String get topExitCategoriesSubtitle;

  /// No description provided for @noCategoryExits.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma categoria com saídas registradas.'**
  String get noCategoryExits;

  /// No description provided for @stockByCategory.
  ///
  /// In pt, this message translates to:
  /// **'Estoque por categoria'**
  String get stockByCategory;

  /// No description provided for @stockByCategorySubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Total de produtos por categoria'**
  String get stockByCategorySubtitle;

  /// No description provided for @noCategoryStock.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto com estoque nessa categoria.'**
  String get noCategoryStock;

  /// No description provided for @stockValueByCategory.
  ///
  /// In pt, this message translates to:
  /// **'Valor parado em estoque por categoria'**
  String get stockValueByCategory;

  /// No description provided for @stockValueByCategorySubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Estoque atual multiplicado pelo preço do produto'**
  String get stockValueByCategorySubtitle;

  /// No description provided for @noStockValue.
  ///
  /// In pt, this message translates to:
  /// **'Cadastre produtos com preço e estoque.'**
  String get noStockValue;

  /// No description provided for @uncategorized.
  ///
  /// In pt, this message translates to:
  /// **'Sem categoria'**
  String get uncategorized;

  /// No description provided for @allCategories.
  ///
  /// In pt, this message translates to:
  /// **'Todas as categorias'**
  String get allCategories;

  /// No description provided for @noProductInCategory.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto encontrado nesta categoria.'**
  String get noProductInCategory;

  /// No description provided for @missingProductDependencies.
  ///
  /// In pt, this message translates to:
  /// **'Cadastre ao menos uma categoria antes de criar produtos.'**
  String get missingProductDependencies;

  /// No description provided for @invalidProductFields.
  ///
  /// In pt, this message translates to:
  /// **'Informe SKU, preço, estoque, categoria e subcategoria válidos.'**
  String get invalidProductFields;

  /// No description provided for @emailNotRegistered.
  ///
  /// In pt, this message translates to:
  /// **'E-mail não cadastrado.'**
  String get emailNotRegistered;

  /// No description provided for @loginEmptyFields.
  ///
  /// In pt, this message translates to:
  /// **'Informe o e-mail e a senha para entrar.'**
  String get loginEmptyFields;

  /// No description provided for @incorrectPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha incorreta ou não cadastrada.'**
  String get incorrectPassword;

  /// No description provided for @invalidCreateAccountEmail.
  ///
  /// In pt, this message translates to:
  /// **'Informe um e-mail válido com @ e final .com.'**
  String get invalidCreateAccountEmail;

  /// No description provided for @searchByCity.
  ///
  /// In pt, this message translates to:
  /// **'Procurar por cidade'**
  String get searchByCity;

  /// No description provided for @availability.
  ///
  /// In pt, this message translates to:
  /// **'Disponibilidade'**
  String get availability;

  /// No description provided for @allSheds.
  ///
  /// In pt, this message translates to:
  /// **'Todos os galpões'**
  String get allSheds;

  /// No description provided for @withAvailableStock.
  ///
  /// In pt, this message translates to:
  /// **'Com estoque disponível'**
  String get withAvailableStock;

  /// No description provided for @withoutAvailableStock.
  ///
  /// In pt, this message translates to:
  /// **'Sem estoque disponível'**
  String get withoutAvailableStock;

  /// No description provided for @withLowStockProducts.
  ///
  /// In pt, this message translates to:
  /// **'Com produtos com baixo estoque'**
  String get withLowStockProducts;

  /// No description provided for @noShedForFilters.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum galpão encontrado para estes filtros.'**
  String get noShedForFilters;

  /// No description provided for @productsInShed.
  ///
  /// In pt, this message translates to:
  /// **'Produtos neste galpão'**
  String get productsInShed;

  /// No description provided for @noProductsInShed.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto cadastrado neste galpão.'**
  String get noProductsInShed;

  /// No description provided for @searchingCep.
  ///
  /// In pt, this message translates to:
  /// **'Buscando CEP...'**
  String get searchingCep;

  /// No description provided for @cepNotFound.
  ///
  /// In pt, this message translates to:
  /// **'CEP não encontrado.'**
  String get cepNotFound;

  /// No description provided for @unableToSearchCep.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível buscar o CEP.'**
  String get unableToSearchCep;

  /// No description provided for @invalidCep.
  ///
  /// In pt, this message translates to:
  /// **'Informe um CEP válido.'**
  String get invalidCep;

  /// No description provided for @searchValidCepBeforeSavingShed.
  ///
  /// In pt, this message translates to:
  /// **'Busque um CEP válido antes de salvar o galpão.'**
  String get searchValidCepBeforeSavingShed;

  /// No description provided for @searchValidCepBeforeCreatingShed.
  ///
  /// In pt, this message translates to:
  /// **'Busque um CEP válido antes de cadastrar o galpão.'**
  String get searchValidCepBeforeCreatingShed;

  /// No description provided for @shedCapacityExceeded.
  ///
  /// In pt, this message translates to:
  /// **'A entrada ultrapassa a capacidade do galpão.'**
  String get shedCapacityExceeded;

  /// No description provided for @productNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe o nome do produto.'**
  String get productNameRequired;

  /// No description provided for @productSkuRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe o SKU do produto.'**
  String get productSkuRequired;

  /// No description provided for @productDescriptionRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe a descrição do produto.'**
  String get productDescriptionRequired;

  /// No description provided for @invalidImageUrl.
  ///
  /// In pt, this message translates to:
  /// **'Informe uma URL de imagem válida ou deixe o campo vazio.'**
  String get invalidImageUrl;

  /// No description provided for @invalidPrice.
  ///
  /// In pt, this message translates to:
  /// **'Informe um preço válido.'**
  String get invalidPrice;

  /// No description provided for @priceGreaterThanZero.
  ///
  /// In pt, this message translates to:
  /// **'O preço precisa ser maior que zero.'**
  String get priceGreaterThanZero;

  /// No description provided for @selectCategory.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma categoria.'**
  String get selectCategory;

  /// No description provided for @selectSubcategory.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma subcategoria.'**
  String get selectSubcategory;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

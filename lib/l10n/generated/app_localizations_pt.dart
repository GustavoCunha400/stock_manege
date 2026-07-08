// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get languageSpanish => 'Espanhol';

  @override
  String get menu => 'Menu';

  @override
  String get stock => 'Estoque';

  @override
  String get categories => 'Categorias';

  @override
  String get sheds => 'Galpões';

  @override
  String get newProduct => 'Novo Produto';

  @override
  String get settings => 'Configurações';

  @override
  String get logout => 'Sair';

  @override
  String get welcome => 'Bem Vindo ao Estokar!';

  @override
  String get loginTitle => 'Entre com sua conta';

  @override
  String get loginSubtitle => 'Acesse sua conta para continuar';

  @override
  String get emailPrompt => 'Entre com seu e-mail:';

  @override
  String get emailCreatePrompt => 'Digite seu E-mail:';

  @override
  String get passwordPrompt => 'Digite sua Senha:';

  @override
  String get emailHint => 'E-mail';

  @override
  String get passwordHint => 'Senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get noAccount => 'Ainda não possui uma conta?';

  @override
  String get createAccount => 'Criar Conta';

  @override
  String get createAccountTitle => 'Crie sua conta';

  @override
  String get createAccountSubtitle =>
      'Crie sua conta e facilite sua gestão conosco';

  @override
  String get alreadyHaveAccount => 'Já possui uma conta?';

  @override
  String get error => 'Erro';

  @override
  String get ok => 'OK';

  @override
  String get fillEmailPassword => 'Preencha email e senha.';

  @override
  String get passwordMinLength => 'A senha deve ter pelo menos 8 caracteres.';

  @override
  String get invalidEmailPassword => 'Email ou senha inválidos.';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get language => 'Idioma';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get darkTheme => 'Tema Escuro';

  @override
  String get active => 'Ativo';

  @override
  String get lightThemeActive => 'Tema Claro ativo';

  @override
  String get noProduct => 'Nenhum produto cadastrado';

  @override
  String get registerProductFirst => 'Cadastre um produto antes.';

  @override
  String get addMovement => 'Adicionar movimentação';

  @override
  String get product => 'Produto';

  @override
  String get observation => 'Observação';

  @override
  String currentStock(String value) {
    return 'Estoque atual: $value';
  }

  @override
  String get entry => 'Entrada';

  @override
  String get exit => 'Saída';

  @override
  String get register => 'Registrar';

  @override
  String get invalidMovementQuantity => 'Informe uma entrada ou saída válida.';

  @override
  String get exitGreaterThanStock =>
      'Estoque insuficiente para realizar esta saída.';

  @override
  String get entryGreaterThanShedCapacity =>
      'A entrada não pode ser maior que a capacidade disponível do galpão.';

  @override
  String get unableToRegister => 'Não foi possível registrar.';

  @override
  String get currentQuantity => 'Quantidade atual';

  @override
  String get entryQuantity => 'Quantidade de entradas';

  @override
  String get exitQuantity => 'Quantidade de saídas';

  @override
  String get entryValue => 'Valor de entrada';

  @override
  String get exitValue => 'Valor de saída';

  @override
  String get finalValue => 'Valor final';

  @override
  String get deleteOrEditItem => 'Excluir ou Editar Item';

  @override
  String get deleteItemQuestion => 'Deseja excluir este item?';

  @override
  String get remove => 'Remover';

  @override
  String get edit => 'Editar';

  @override
  String get no => 'Não';

  @override
  String get categoriesAndSubcategories => 'Categorias e Subcategorias';

  @override
  String get noCategory => 'Nenhuma categoria cadastrada';

  @override
  String get searchProductByCategory => 'Procurar por produto da categoria';

  @override
  String get noCategoryFoundForProduct =>
      'Nenhuma categoria encontrada para este produto.';

  @override
  String get deleteOrEditCategory => 'Excluir ou editar categoria';

  @override
  String get deleteCategoryQuestion => 'Deseja excluir esta categoria?';

  @override
  String get addSubcategory => 'Adicionar subcategoria';

  @override
  String get addCategory => 'Adicionar categoria';

  @override
  String get name => 'Nome';

  @override
  String get sku => 'SKU';

  @override
  String get description => 'Descrição';

  @override
  String get subcategoriesSeparated => 'Subcategorias separadas por vírgula';

  @override
  String get add => 'Adicionar';

  @override
  String get shedsTitle => 'Galpões';

  @override
  String get noShed => 'Nenhum galpão cadastrado';

  @override
  String get invalidCapacity => 'Informe uma capacidade válida.';

  @override
  String get capacity => 'Capacidade';

  @override
  String capacityValue(String value) {
    return 'Capacidade: $value';
  }

  @override
  String usedCapacityValue(String value) {
    return 'Usado: $value';
  }

  @override
  String get deleteOrEditShed => 'Excluir ou editar galpão';

  @override
  String get addShed => 'Adicionar galpão';

  @override
  String get location => 'Localização';

  @override
  String get createNewProduct => 'Criar novo produto';

  @override
  String get imageUrl => 'URL da Imagem';

  @override
  String get price => 'Preço';

  @override
  String get category => 'Categoria';

  @override
  String get subcategory => 'Subcategoria';

  @override
  String get shed => 'Galpão';

  @override
  String get create => 'Criar';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get registeredProducts => 'Produtos cadastrados';

  @override
  String get stockItems => 'Itens em estoque';

  @override
  String get totalStockValue => 'Valor total em estoque';

  @override
  String get lowStock => 'Baixo estoque';

  @override
  String get lowStockLimit => 'Limite para baixo estoque';

  @override
  String upToUnits(String value) {
    return 'Até $value unidades';
  }

  @override
  String get totalEntries => 'Quantidade de entradas';

  @override
  String get totalExits => 'Quantidade de saídas';

  @override
  String get recentMovements => 'Movimentações recentes';

  @override
  String get recentMovementsSubtitle =>
      'Entradas e saídas registradas nos últimos 7 dias';

  @override
  String get noRecentMovements => 'Nenhuma movimentação registrada.';

  @override
  String get topExitProducts => 'Produtos com mais saídas';

  @override
  String get topExitProductsSubtitle => 'Quantidade total retirada por produto';

  @override
  String get noProductExits => 'Nenhum produto com saídas registradas.';

  @override
  String get topExitCategories => 'Categorias com mais saídas';

  @override
  String get topExitCategoriesSubtitle =>
      'Quantidade total retirada por categoria';

  @override
  String get noCategoryExits => 'Nenhuma categoria com saídas registradas.';

  @override
  String get stockByCategory => 'Estoque por categoria';

  @override
  String get stockByCategorySubtitle => 'Total de produtos por categoria';

  @override
  String get noCategoryStock => 'Nenhum produto com estoque nessa categoria.';

  @override
  String get stockValueByCategory => 'Valor parado em estoque por categoria';

  @override
  String get stockValueByCategorySubtitle =>
      'Estoque atual multiplicado pelo preço do produto';

  @override
  String get noStockValue => 'Cadastre produtos com preço e estoque.';

  @override
  String get uncategorized => 'Sem categoria';

  @override
  String get allCategories => 'Todas as categorias';

  @override
  String get noProductInCategory =>
      'Nenhum produto encontrado nesta categoria.';

  @override
  String get missingProductDependencies =>
      'Cadastre ao menos uma categoria antes de criar produtos.';

  @override
  String get invalidProductFields =>
      'Informe SKU, preço, estoque, categoria e subcategoria válidos.';

  @override
  String get emailNotRegistered => 'E-mail não cadastrado.';

  @override
  String get loginEmptyFields => 'Informe o e-mail e a senha para entrar.';

  @override
  String get incorrectPassword => 'Senha incorreta ou não cadastrada.';

  @override
  String get invalidCreateAccountEmail =>
      'Informe um e-mail válido com @ e final .com.';

  @override
  String get searchByCity => 'Procurar por cidade';

  @override
  String get availability => 'Disponibilidade';

  @override
  String get allSheds => 'Todos os galpões';

  @override
  String get withAvailableStock => 'Com estoque disponível';

  @override
  String get withoutAvailableStock => 'Sem estoque disponível';

  @override
  String get withLowStockProducts => 'Com produtos com baixo estoque';

  @override
  String get noShedForFilters => 'Nenhum galpão encontrado para estes filtros.';

  @override
  String get productsInShed => 'Produtos neste galpão';

  @override
  String get noProductsInShed => 'Nenhum produto cadastrado neste galpão.';

  @override
  String get searchingCep => 'Buscando CEP...';

  @override
  String get cepNotFound => 'CEP não encontrado.';

  @override
  String get unableToSearchCep => 'Não foi possível buscar o CEP.';

  @override
  String get invalidCep => 'Informe um CEP válido.';

  @override
  String get searchValidCepBeforeSavingShed =>
      'Busque um CEP válido antes de salvar o galpão.';

  @override
  String get searchValidCepBeforeCreatingShed =>
      'Busque um CEP válido antes de cadastrar o galpão.';

  @override
  String get shedCapacityExceeded =>
      'A entrada ultrapassa a capacidade do galpão.';

  @override
  String get productNameRequired => 'Informe o nome do produto.';

  @override
  String get productSkuRequired => 'Informe o SKU do produto.';

  @override
  String get productDescriptionRequired => 'Informe a descrição do produto.';

  @override
  String get invalidImageUrl =>
      'Informe uma URL de imagem válida ou deixe o campo vazio.';

  @override
  String get invalidPrice => 'Informe um preço válido.';

  @override
  String get priceGreaterThanZero => 'O preço precisa ser maior que zero.';

  @override
  String get selectCategory => 'Selecione uma categoria.';

  @override
  String get selectSubcategory => 'Selecione uma subcategoria.';
}

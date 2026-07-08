import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/dialog_input_decoration.dart';
import '../../../../core/utils/show_error_dialog.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../controllers/product_controller.dart';
import '../controllers/shed_controller.dart';
import '../controllers/stock_movement_form_controller.dart';

class AddMovimentation {
  Future<void> call({
    required BuildContext context,
    required TextEditingController entradaController,
    required TextEditingController saidaController,
    required TextEditingController observationController,
    required bool Function() isMounted,
  }) async {
    final productController = context.read<ProductController>();
    final shedController = context.read<ShedController>();
    final l10n = AppLocalizations.of(context)!;

    if (productController.products.isEmpty) {
      await productController.loadProducts();
    }
    if (shedController.sheds.isEmpty) {
      await shedController.loadSheds();
    }
    if (!isMounted()) return;

    final itens = productController.products;
    if (itens.isEmpty) {
      await showErrorDialog(context, l10n.registerProductFirst);
      return;
    }
    final sheds = shedController.sheds;
    if (sheds.isEmpty) {
      await showErrorDialog(context, l10n.missingProductDependencies);
      return;
    }
    entradaController.clear();
    saidaController.clear();
    observationController.clear();
    context
        .read<StockMovementFormController>()
        .start(itens, initialShedId: sheds.first.id);
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Consumer<StockMovementFormController>(
          builder: (context, formController, child) {
            final selectedProduct = _firstWhereOrNull(
              itens,
              (product) => product.id == formController.selectedProductId,
            );
            final selectedShed = _firstWhereOrNull(
              sheds,
              (shed) => shed.id == formController.selectedShedId,
            );
            final selectedStockQuantity =
                selectedProduct == null || selectedShed == null
                ? null
                : productController.stockForProductInShedUntil(
                    selectedProduct.id,
                    selectedShed.id,
                    formController.selectedDate,
                  );
            final formattedMovementDate = MaterialLocalizations.of(
              context,
            ).formatShortDate(formController.selectedDate);
            return AlertDialog(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: Navigator.of(context).pop,
                      icon: const Icon(Icons.close,size: 18,)
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.addMovement,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 420,
                  maxHeight: MediaQuery.sizeOf(context).height * 0.55,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  DropdownButtonFormField<String>(
                    value: formController.selectedProductId,
                    isExpanded: true,
                    decoration: dialogInputDecoration(context, l10n.product),
                    items: itens
                        .map(
                          (product) => DropdownMenuItem(
                            value: product.id,
                            child: Text(
                              product.nome,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: formController.selectProduct,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: observationController,
                    decoration: dialogInputDecoration(context, l10n.observation),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      final now = DateTime.now();
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: formController.selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(now.year, now.month, now.day),
                      );
                      if (pickedDate == null) return;

                      formController.selectDate(pickedDate);
                    },
                    child: InputDecorator(
                      decoration: dialogInputDecoration(
                        context,
                        'Data da movimentação',
                      ).copyWith(
                        suffixIcon: const Icon(Icons.calendar_today_outlined,
                          size: 18,
                        ),
                      ),
                      child: Text(
                        formattedMovementDate,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: entradaController,
                    decoration: dialogInputDecoration(context, l10n.entry),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: saidaController,
                    decoration: dialogInputDecoration(context, l10n.exit),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: formController.selectedShedId,
                    isExpanded: true,
                    decoration: dialogInputDecoration(context, l10n.shed),
                    items: sheds
                        .map(
                          (shed) => DropdownMenuItem(
                        value: shed.id,
                        child: Text(
                          shed.nome,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: sheds.isEmpty ? null : formController.selectShed,
                  ),
                  const SizedBox(height: 5),
                  if (selectedStockQuantity != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          l10n.currentStock('$selectedStockQuantity'),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final observation = observationController.text.trim();
                    final entrada = entradaController.text.trim().isEmpty
                        ? 0
                        : int.tryParse(entradaController.text.trim());
                    final saida = saidaController.text.trim().isEmpty
                        ? 0
                        : int.tryParse(saidaController.text.trim());
                    if (selectedProduct == null ||
                        selectedShed == null ||
                        entrada == null ||
                        saida == null ||
                        entrada < 0 ||
                        saida < 0 ||
                        entrada == 0 && saida == 0) {
                      await showErrorDialog(
                        context,
                        l10n.invalidMovementQuantity,
                      );
                      return;
                    }
                    if (saida > 0 &&
                        !productController.canRemoveStock(
                          productId: selectedProduct.id,
                          shedId: selectedShed.id,
                          quantity: saida,
                        )) {
                      await showErrorDialog(
                        context,
                        l10n.exitGreaterThanStock,
                      );
                      return;
                    }
                    final resultingShedStock =
                        productController.stockForShedUntil(
                          selectedShed.id,
                          formController.selectedDate,
                        ) +
                        entrada -
                        saida;
                    if (resultingShedStock > selectedShed.maxCapacity) {
                      await showErrorDialog(
                        context,
                        l10n.shedCapacityExceeded,
                      );
                      return;
                    }
                    final success = await productController.registerMovement(
                      productId: selectedProduct.id,
                      observation: observation,
                      shedId: selectedShed.id,
                      shedName: selectedShed.nome,
                      entryQuantity: entrada,
                      exitQuantity: saida,
                      createdAt: formController.selectedDate,
                    );
                    if (!success) {
                      await showErrorDialog(
                        context,
                        l10n.unableToRegister,
                      );
                      return;
                    }
                    if (!isMounted()) return;
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.register),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}



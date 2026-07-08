import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../core/utils/dialog_input_decoration.dart';
import '../../../../core/utils/show_error_dialog.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/shed_stock.dart';
import '../controllers/shed_controller.dart';

class EditShedDialog {
  Future<void> call({
    required BuildContext context,
    required ShedStock shed,
    required TextEditingController nameController,
    required TextEditingController locateController,
    required TextEditingController maxCapacityController,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final cepController = TextEditingController();

    void clearForm() {
      nameController.clear();
      locateController.clear();
      maxCapacityController.clear();
    }

    nameController.text = shed.nome;
    locateController.text = shed.locate;
    maxCapacityController.text = shed.maxCapacity.toString();

    String onlyDigits(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

    Future<String?> findCityByCep(String cep) async {
      final cleanCep = cep.replaceAll(RegExp(r'\D'), '');

      if (cleanCep.length != 8) {
        return null;
      }

      final url = Uri.parse('https://viacep.com.br/ws/$cleanCep/json/');

      try {
        final response = await http.get(url);

        if (response.statusCode != 200) {
          return null;
        }

        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['erro'] == true) {
          return null;
        }

        final city = data['localidade']?.toString().trim() ?? '';
        final state = data['uf']?.toString().trim() ?? '';

        if (city.isEmpty || state.isEmpty) {
          return null;
        }

        return '$city - $state';
      } catch (_) {
        return null;
      }
    }

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
        var isSearchingCep = false;
        String? cepError;
        var lastCepSearch = 0;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> searchCep(String value) async {
              final cep = onlyDigits(value);
              final searchId = ++lastCepSearch;

              if (cep.length < 8) {
                setDialogState(() {
                  cepError = null;
                  isSearchingCep = false;
                });
                return;
              }

              setDialogState(() {
                isSearchingCep = true;
                cepError = null;
              });

              try {
                final city = await findCityByCep(cep);

                if (!dialogContext.mounted) return;
                if (searchId != lastCepSearch) return;

                setDialogState(() {
                  locateController.text = city ?? shed.locate;
                  cepError = city == null ? l10n.cepNotFound : null;
                  isSearchingCep = false;
                });
              } catch (_) {
                if (!dialogContext.mounted) return;
                if (searchId != lastCepSearch) return;

                setDialogState(() {
                  cepError = l10n.unableToSearchCep;
                  isSearchingCep = false;
                });
              }
            }

            return AlertDialog(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: Navigator.of(dialogContext).pop,
                    icon: const Icon(Icons.close,size: 18,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(l10n.edit),
                    ],
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: dialogInputDecoration(context, l10n.name),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: cepController,
                      decoration: dialogInputDecoration(
                        context,
                        isSearchingCep ? l10n.searchingCep : 'CEP',
                      ).copyWith(errorText: cepError),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      onChanged: searchCep,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: locateController,
                      decoration: dialogInputDecoration(context, l10n.location),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: maxCapacityController,
                      decoration: dialogInputDecoration(context, l10n.capacity),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    clearForm();
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final cep = onlyDigits(cepController.text);

                    if (cep.isNotEmpty && cep.length != 8) {
                      await showErrorDialog(context, l10n.invalidCep);
                      return;
                    }

                    if (cep.isNotEmpty && locateController.text.trim().isEmpty) {
                      await showErrorDialog(
                        context,
                        l10n.searchValidCepBeforeSavingShed,
                      );
                      return;
                    }

                    final wasEdited = await context
                        .read<ShedController>()
                        .editShed(
                          shed: shed,
                          nome: nameController.text,
                          locate: locateController.text,
                          maxCapacity:
                              int.tryParse(maxCapacityController.text) ?? 0,
                        );

                    if (!wasEdited) {
                      await showErrorDialog(context, l10n.invalidCapacity);
                      return;
                    }

                    clearForm();

                    if (!context.mounted) return;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
        },
      );
    } finally {
      clearForm();
      cepController.dispose();
    }
  }
}



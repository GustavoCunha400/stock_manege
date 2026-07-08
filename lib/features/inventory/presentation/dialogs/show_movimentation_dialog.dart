import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/stock_movement.dart';

class ShowMovimentationDialog {
  Future<void> call({
    required BuildContext context,
    required List<StockMovement> movements,
    String? shedId,
    String? shedName,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final filteredMovements = (shedId == null
        ? movements.toList()
        : movements.where((movement) => movement.shedId == shedId).toList())
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final screenSize = MediaQuery.sizeOf(dialogContext);
        final dialogTitle = shedName == null
            ? l10n.recentMovements
            : '${l10n.recentMovements} - $shedName';

        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 280,
              maxWidth: 560,
              maxHeight: screenSize.height * 0.8,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dialogTitle,
                          style: Theme.of(dialogContext).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: Navigator.of(dialogContext).pop,
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  if (filteredMovements.isEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(l10n.noRecentMovements),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredMovements.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final movement = filteredMovements[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (movement.entryQuantity > 0)
                                _MovementCard(
                                  movement: movement,
                                  title: l10n.entry,
                                  quantityLabel: l10n.entryQuantity,
                                  valueLabel: l10n.entryValue,
                                  quantity: movement.entryQuantity,
                                  icon: Icons.arrow_downward,
                                  backgroundColor: const Color(0xFFE3F2FD),
                                  iconColor: const Color(0xFF1565C0),
                                ),
                              if (movement.entryQuantity > 0 &&
                                  movement.exitQuantity > 0)
                                const SizedBox(height: 8),
                              if (movement.exitQuantity > 0)
                                _MovementCard(
                                  movement: movement,
                                  title: l10n.exit,
                                  quantityLabel: l10n.exitQuantity,
                                  valueLabel: l10n.exitValue,
                                  quantity: movement.exitQuantity,
                                  icon: Icons.arrow_upward,
                                  backgroundColor: const Color(0xFFFFEBEE),
                                  iconColor: const Color(0xFFC62828),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MovementCard extends StatelessWidget {
  final StockMovement movement;
  final String title;
  final String quantityLabel;
  final String valueLabel;
  final int quantity;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _MovementCard({
    required this.movement,
    required this.title,
    required this.quantityLabel,
    required this.valueLabel,
    required this.quantity,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final observation = movement.observation.trim();
    final movementValue = quantity * movement.unitPrice;
    final resultingStockValue = movement.resultingStock * movement.unitPrice;
    final movementDate = DateFormat.yMd(
      Localizations.localeOf(context).toString(),
    ).format(movement.createdAt);

    return Card(
      color: backgroundColor,
      margin: EdgeInsets.zero,
      child: ListTile(
        textColor: const Color(0xFF182033),
        leading: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.75),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          '$title - ${movement.productName}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${ifNotEmpty(l10n.observation, observation)}'
          'Data: $movementDate\n'
          '$quantityLabel: $quantity | '
          '$valueLabel: R\$ ${movementValue.toStringAsFixed(2)}\n'
          '${l10n.shed}: ${movement.shedName}\n'
          '${l10n.currentStock('${movement.resultingStock}')} | '
          '${l10n.finalValue}: R\$ ${resultingStockValue.toStringAsFixed(2)}',
          style: const TextStyle(color: Color(0xFF2F384C)),
        ),
      ),
    );
  }

  String ifNotEmpty(String label, String value) {
    if (value.isEmpty) return '';
    return '$label: $value\n';
  }
}



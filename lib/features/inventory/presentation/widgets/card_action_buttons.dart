import 'package:flutter/material.dart';
import 'package:estokar_gestaodeestoque/app/app_breakpoints.dart';

class CardActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final buttonSize = isMobile ? 30.0 : 36.0;
    final buttonHeight = isMobile ? 28.0 : 32.0;
    final iconSize = isMobile ? 16.0 : 18.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(
            width: buttonSize,
            height: buttonHeight,
          ),
          onPressed: onEdit,
          icon: Icon(Icons.edit, size: iconSize),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(
            width: buttonSize,
            height: buttonHeight,
          ),
          onPressed: onDelete,
          icon: Icon(Icons.delete, size: iconSize),
        ),
      ],
    );
  }
}

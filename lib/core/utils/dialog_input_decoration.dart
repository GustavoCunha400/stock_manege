import 'package:flutter/material.dart';

InputDecoration dialogInputDecoration(
  BuildContext context,
  String labelText, {
  String? prefixText,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final borderRadius = BorderRadius.circular(8);

  return InputDecoration(
    labelText: labelText,
    prefixText: prefixText,
    border: OutlineInputBorder(borderRadius: borderRadius),
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
  );
}


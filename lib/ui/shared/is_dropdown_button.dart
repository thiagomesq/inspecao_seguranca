import 'package:flutter/material.dart';

class ISDropdownButton extends StatelessWidget {
  final String? labelText;
  final List<DropdownMenuItem> items;
  final void Function(dynamic)? onChanged;
  final dynamic initialValue;
  final bool enabled;
  const ISDropdownButton({
    super.key,
    this.labelText,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: items,
      onChanged: onChanged,
      value: initialValue,
      isExpanded: true,
      style: TextStyle(
        fontSize: 22,
        color: Theme.of(context).colorScheme.onBackground,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        enabled: enabled,
        labelText: labelText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
    );
  }
}

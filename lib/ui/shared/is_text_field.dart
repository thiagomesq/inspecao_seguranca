import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ISTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? labelText;
  final void Function(String)? onChanged;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isDatePicker;
  final TextEditingController? controller;
  final DateTime? firstDate;
  final bool? isEnable;
  final FocusNode? focusNode;
  const ISTextField({
    super.key,
    this.keyboardType,
    this.labelText,
    this.onChanged,
    this.initialValue,
    this.inputFormatters,
    this.isDatePicker,
    this.controller,
    this.firstDate,
    this.isEnable,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    if (controller != null && initialValue != null) {
      controller!.text = initialValue!;
    }
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
      ),
      onChanged: onChanged,
      readOnly: isDatePicker ?? false,
      enabled: isEnable ?? true,
      onTap: isDatePicker != null && isDatePicker!
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: firstDate != null ? firstDate! : DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                String formattedDate = DateFormat('MM-dd-yyyy').format(date);
                controller!.text = formattedDate;
                onChanged!(formattedDate);
              }
            }
          : null,
    );
  }
}

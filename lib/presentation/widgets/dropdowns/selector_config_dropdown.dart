import 'package:flutter/material.dart';

class SelectorConfigDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T item) itemAsString;
  final ValueChanged<T?> onChanged;

  const SelectorConfigDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemAsString(item),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
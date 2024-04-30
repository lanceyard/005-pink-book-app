import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

class DropdownField extends StatefulWidget {
  const DropdownField({
    Key? key,
    required this.isLoading,
    this.label,
    required this.items,
    this.hint,
    this.selectedItem,
    this.validator,
    this.onChanged, // Tambahkan properti onChanged
  }) : super(key: key);

  final bool isLoading;
  final String? label;
  final List<String> items; // Ensure items is a non-empty list
  final String? hint;
  final String? selectedItem;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged; // Tambahkan properti onChanged

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String? _selectedValue;
  
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedValue, // Pre-select based on initial value
      validator: widget.validator,
      onChanged: (value) {
        setState(() {
          _selectedValue = value; // Update selected value
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value!); // Panggil onChanged jika tersedia
        }
        print('Selected value: $_selectedValue');
      },
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: hintTextStyle,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: oldRedColor),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: oldRedColor),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: widget.hint,
        hintStyle: hintTextStyle,
      ),
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: hintTextStyle),
        );
      }).toList(),
      disabledHint: widget.isLoading ? const Text('Loading...') : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';

class CommonDropdown extends StatelessWidget {
  final String label;
  final String? initialValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final  double? borderRadius ;
   const CommonDropdown({
    super.key,
    required this.label,
    required this.items,
    this.initialValue,
    this.borderRadius=12.0,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      value: initialValue ?? (items.isNotEmpty ? items.first : null),
      decoration: InputDecoration(
        labelStyle: commonTextStyle(
          color: colorText,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        labelText: label,
        border:
         commonTextFiledBorder(borderRadius: borderRadius),
        enabledBorder:
        commonTextFiledBorder(borderRadius: borderRadius),
        focusedBorder:
       commonTextFiledBorder(borderRadius: borderRadius),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      ),
      isExpanded: true,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
          value: item,
          child: commonText(text: item, overflow: TextOverflow.ellipsis),
        ),
      )
          .toList(),
      onChanged: onChanged,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}

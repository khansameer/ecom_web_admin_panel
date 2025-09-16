import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class CommonDropdown extends StatelessWidget {
  final String? initialValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double? borderRadius;
  final bool enabled;
  const CommonDropdown({
    super.key,

    required this.items,
    this.initialValue,
    this.enabled = true, // default true
    this.borderRadius = 12.0,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,provider,child) {
        return DropdownButtonFormField2<String>(
          value: initialValue ?? (items.isNotEmpty ? items.first : null),
          decoration: InputDecoration(
            enabled: enabled,
            border: commonTextFiledBorder(borderRadius: borderRadius),
            enabledBorder: commonTextFiledBorder(borderRadius: borderRadius),
            focusedBorder: commonTextFiledBorder(borderRadius: borderRadius),
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
          onChanged: enabled ? onChanged : null, // 👈 अब disable होगा
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            decoration: BoxDecoration(
              color: provider.isDark?colorDarkBgColor:Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 12),
          ),
        );
      }
    );
  }
}

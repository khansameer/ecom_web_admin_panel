import 'package:flutter/material.dart';

class CommonSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeThumbColor;
  final Color inactiveThumbColor;
  final Color activeTrackColor;
  final Color inactiveTrackColor;

  const CommonSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeThumbColor = Colors.white,
    this.inactiveThumbColor = Colors.grey,
    this.activeTrackColor = Colors.blue,
    this.inactiveTrackColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: activeThumbColor,
      inactiveThumbColor: inactiveThumbColor,
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: inactiveTrackColor,
    );
  }
}

import 'package:flutter/material.dart';

class CommonSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double scale;
  final Color activeThumbColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;

  const CommonSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.scale = 0.8,
    this.activeThumbColor = Colors.green,
    this.inactiveThumbColor = Colors.grey,
    this.inactiveTrackColor = const Color(0xFFBDBDBD),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Switch(
        value: value,
        activeThumbColor: activeThumbColor,
        inactiveThumbColor: inactiveThumbColor,
        inactiveTrackColor: inactiveTrackColor.withOpacity(0.4),
        onChanged: onChanged,
      ),
    );
  }
}
